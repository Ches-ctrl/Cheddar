module Ats
  module Greenhouse
    module CompanyDetails
      def company_details(ats_identifier)
        url_ats_api = "#{url_api}#{ats_identifier}/"
        url_ats_main = "#{url_base}#{ats_identifier}/"
        data = get_json_data(url_ats_api)
        return {} unless data

        url_careers = check_for_careers_url_redirect(url_ats_main)
        {
          name: data['name'],
          description: Flipper.enabled?(:company_description) ? data['content'] : 'Not added yet',
          url_ats_api:,
          url_ats_main:,
          url_careers:,
          url_website: fetch_website_from_careers_page(url_careers),
          total_live: fetch_total_live(ats_identifier)
        }
      end

      private

      def check_for_careers_url_redirect(ats_url)
        p "checking for careers url redirect: #{ats_url}"
        url = URI(ats_url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true if url.scheme == 'https'
        request = Net::HTTP::Get.new(url.request_uri)

        max_retries = 2
        retries = 0
        begin
          response = http.request(request)
        rescue Errno::ECONNRESET, OpenSSL::SSL::SSLError => e
          retries += 1
          if retries <= max_retries
            sleep(2**retries) # Exponential backoff
            retry
          else
            puts "Check for careers redirect failed after #{max_retries} retries: #{e.message}"
            return false
          end
        end

        if response.is_a?(Net::HTTPRedirection)
          response['Location']
        else
          p "No redirect for #{ats_url}"
          ats_url
        end
      end

      def fetch_website_by_parsing(url)
        return if url.include?('greenhouse')

        p "parsing #{url} to get company website..."
        uri = URI(url)
        "#{uri.scheme}://#{uri.host}"
      end

      def fetch_website_by_scraping(url, attribute = 'href')
        locator = new_format?(url) ? 'a.logo' : '#logo > a'
        Importer::Scraper::PageInfoFetcher.call(url, locator, attribute)
      end

      def fetch_website_from_careers_page(url)
        fetch_website_by_parsing(url) || fetch_website_by_scraping(url)
      end

      def new_format?(url) = url.include?('job-boards')
    end
  end
end
