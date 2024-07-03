module Importer
  module Xml
  class WorkableParser < ApplicationService
    WORKABLE_URL = 'https://www.workable.com/boards/workable.xml'
    LOCAL_XML_PATH = 'workable.xml'
    S3_BUCKET = 'your bucket name' # please enter your bucket name
    S3_REGION = 'your regoin' # please enter your bucket region
    S3_KEY = 'workable.xml'
    REDIRECTED_URLS_PATH = 'redirected_urls.json'
    MAX_RETRIES = 5
    RETRY_DELAY = 5

    def initialize
      puts("Started parser initializer")
      @s3_client = Aws::S3::Client.new(region: S3_REGION)
    end

    def import_jobs
    #   stream_and_save_xml
      parse_xml
      save_and_upload
      create_jobs
    end

    private

    def stream_and_save_xml
      puts("Started stream_and_save_xml")
      response = retry_request do
        Faraday.get(WORKABLE_URL) do |req|
          req.options.timeout = 600
          req.options.open_timeout = 600
        end
      end

      if response
        File.open(LOCAL_XML_PATH, 'wb') do |file|
          response.body.each do |chunk|
            file.write(chunk)
          end
        end
        puts "File saved: #{LOCAL_XML_PATH}"
        upload_to_s3(LOCAL_XML_PATH, S3_KEY)
      else
        puts "Failed to save file."
      end
    end

    def retry_request
      retries = 0
      begin
        response = yield
        puts "Response status: #{response.status}, Response body length: #{response.body.length}"
        if response.status == 429 # Too Many Requests
          raise Faraday::Error, "Too Many Requests"
        end
        response
      rescue Faraday::Error => e
        puts "Request failed: #{e.message}"
        retries += 1
        if retries <= MAX_RETRIES
          delay = RETRY_DELAY * (2 ** (retries - 1)) # Exponential backoff
          puts "Retrying in #{delay} seconds..."
          sleep delay
          retry
        else
          puts "Failed after #{MAX_RETRIES} retries: #{e.message}"
          nil
        end
      end
    end

    def parse_xml
      puts("Started parse_xml")
      if File.exist?(LOCAL_XML_PATH)
        @doc = Nokogiri::XML(File.open(LOCAL_XML_PATH))
        @urls = @doc.xpath('//url').map { |url| url.text.strip }
      else
        puts "File not found: #{LOCAL_XML_PATH}"
      end
    end

    def save_and_upload
      puts("Started save_and_upload")
      File.open(REDIRECTED_URLS_PATH, 'w') { |file| file.write(@urls.to_json) }
      upload_to_s3(REDIRECTED_URLS_PATH)
    end

    def upload_to_s3(local_path)
      puts("Started upload_to_s3")
      File.open(local_path, 'rb') do |file|
        @s3_client.put_object(bucket: S3_BUCKET, key: local_path, body: file)
      end
      puts "Uploaded #{local_path} to S3 bucket #{S3_BUCKET} as #{local_path}"
    end

    def create_jobs
      print("Total number of URLs are #{@urls.count}")
    end
  end
  end
end