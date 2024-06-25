module Importer
    module Xml
        # Docs: https://help.workable.com/hc/en-us/articles/4420464031767-Utilizing-the-XML-Job-Feed
        # To use this: rake xml:workable
        # NB. the Workable XML feed is sensitive to 403 Forbidden errors (too many requests)
        # How this works: The feed includes urls of the format: https://apply.workable.com/j/9A5B371BA0 (i.e. without the ats_identifier)
        # In order to handle this, we create a variable with all the job_posting_urls from the XML feed
        # We then resolve the redirect to get the final url and build the company / job posting from the API via CreateJobFromUrl, this bypasses rate limiting problems and uses standard functionality
        require 'faraday'
        require 'nokogiri'
        require 'aws-sdk-s3'
        require 'json'
        require 'logger'
        class Workable < ApplicationService
            # TODO: Fix this as only capturing a portion of the redirect urls at the moment. There is a wait screen page that is sometimes coming up and it may require a proxy to process. Check for the interim response code. Setup a proxy and use a different IP address to check the page.
            # TODO: Add count for number of urls in XML feed and number of urls processed so that we can evaluate success rate
    
            # TODO: This can be made more efficient in future as lots of the job_posting_urls will already exist in the database after the first run
            # TODO: What we can do is extract the ats_identifiers from the job_posting_urls and then exclude any for which the company already exists in the DB (as this will have a separate process)

            WORKABLE_XML_URL = 'https://apply.workable.com/feed/xml'.freeze
            S3_BUCKET = 'your-s3-bucket'.freeze
            S3_KEY = 'workable_feed.xml'.freeze
            S3_REGION = 'region'.freeze
    
            def initialize
                @ats = ApplicantTrackingSystem.find_by(name: 'Workable')
                @connection = Faraday.new do |conn|
                conn.request :retry, max: 5, interval: 0.05, backoff_factor: 2
                conn.adapter Faraday.default_adapter
                end
                @s3_client = Aws::S3::Client.new(region: S3_REGION)
            end

            def import
                response = @connection.get(WORKABLE_XML_URL)
                if response.status == 200
                  xml_file_path = store_xml_locally(response.body)
                  upload_to_s3(xml_file_path)
                  urls = parse_xml(response.body)
                  redirected_urls = resolve_redirects(urls)
                  save_redirected_urls_locally(redirected_urls)
                  submit_urls(redirected_urls)
                else
                  handle_error(response)
                end
            end

            private

            def store_xml_locally(xml_content)
                file_path = 'tmp/workable_feed.xml'
                File.open(file_path, 'wb') { |file| file.write(xml_content) }
                file_path
            end

            def upload_to_s3(file_path)
                @s3_client.put_object(bucket: S3_BUCKET, key: S3_KEY, body: File.open(file_path))
            end

            def parse_xml(xml_content)
                urls = []
                Nokogiri::XML::Reader(xml_content).each do |node|
                    if node.name == 'url' && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
                        urls << node.inner_xml
                    end
                end
                urls
            end

            def resolve_redirects(urls)
                urls.map do |url|
                    response = follow_redirects(url)
                    response.headers['location'] || url
                end
            end

            def follow_redirects(url)
                connection = Faraday.new(url: url) do |conn|
                    conn.adapter Faraday.default_adapter
                end
                connection.get
            end

            def save_redirected_urls_locally(urls)
                File.open('tmp/redirected_urls.json', 'w') do |file|
                    file.write(urls.to_json)
                end
            end

            def submit_urls(urls)
                urls.each do |url|
                    URL::CreateJobFromUrl.call(url)
                end
            end

            def handle_error(response)
                case response.status
                when 403
                    @logger.error('Too many requests. Please try again later.')
                else
                    @logger.error("Error: #{response.status}")
                end
            end

        end
    end
end
  
# The below is for testing the redirect functionality without hitting the XML feed (comment out the above and use this)
# job_urls = ["https://apply.workable.com/j/9A5B371BA0", "https://apply.workable.com/j/2595A6EDD0", "https://apply.workable.com/j/2DA044E84E", "https://apply.workable.com/j/5ECBE14794", "https://apply.workable.com/j/F44ED9E40A", "https://apply.workable.com/j/0908074E5D", "https://apply.workable.com/j/0AA38013AC", "https://apply.workable.com/j/8D801CE251", "https://apply.workable.com/j/E91B0F3F46", "https://apply.workable.com/j/802966A156"]
  