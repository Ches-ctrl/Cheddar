module Importer
  module Xml
    class WorkableParser < ApplicationService
      WORKABLE_URL = 'https://www.workable.com/boards/workable.xml'
      LOCAL_XML_PATH = 'workable.xml'
      S3_BUCKET = 'S3_BUCKET_NAME' # please enter your bucket name
      S3_REGION = 'S3_REGION' # please enter your bucket region
      REDIRECTED_URLS_PATH = 'redirected_urls.json'
      MAX_RETRIES = 5 # workable allow 5 tries in certain time frame
      RETRY_DELAY = 5

      def initialize
        puts("Started parser initializer")
        @s3_client = Aws::S3::Client.new(region: S3_REGION)
      end

      def import_jobs
        stream_and_save_xml
        parse_xml
        save_and_upload
        create_jobs
      end

      private

      def stream_and_save_xml
        puts "Started stream_and_save_xml"
        uri = URI.parse(WORKABLE_URL)
        Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
          request = Net::HTTP::Get.new(uri.request_uri)
          begin
            http.request(request) do |response|
              if response.is_a?(Net::HTTPSuccess)
                File.open(LOCAL_XML_PATH, 'wb') do |file|
                  total_size = response['content-length'].to_i
                  downloaded_size = 0
                  response.read_body do |chunk|
                    file.write(chunk)
                    downloaded_size += chunk.size
                    if total_size.positive?
                      puts "Chunk download progress: #{((downloaded_size.to_f / total_size) * 100).round(2)}%"
                    else
                      puts "Chunk download progress: #{(downloaded_size.to_f / (downloaded_size + 1) * 100).round(2)}%"
                    end
                  end
                end
                puts "File saved: #{LOCAL_XML_PATH}"
              else
                puts "Failed to retrieve file: #{response.code} #{response.message}"
              end
            end
          rescue StandardError => e
            puts "Request failed: #{e.message}. Retrying..."
            retry_request { stream_and_save_xml } # Retry the whole download in case of any error
          end
        end
      end

      def retry_request
        retries = 0
        begin
          yield
        rescue StandardError => e
          retries += 1
          if retries <= MAX_RETRIES
            delay = RETRY_DELAY * (2 ** (retries - 1)) # Exponential backoff
            puts "Retrying in #{delay} seconds..."
            sleep delay
            retry
          else
            puts "Failed after #{MAX_RETRIES} retries: #{e.message}"
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
        File.write(REDIRECTED_URLS_PATH, @urls.to_json)
        # upload_to_s3(REDIRECTED_URLS_PATH)
      end

      def upload_to_s3(local_path)
        puts("Started upload_to_s3")
        File.open(local_path, 'rb') do |file|
          @s3_client.put_object(bucket: S3_BUCKET, key: local_path, body: file)
        end
        puts "Uploaded #{local_path} to S3 bucket #{S3_BUCKET} as #{local_path}"
      end

      def create_jobs
        print("Total number of URLs are #{@urls.count}. Please create jobs as per need. \n")
      end
    end
  end
end
