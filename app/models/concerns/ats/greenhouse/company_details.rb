module Ats
  module Greenhouse
    module CompanyDetails
      def company_details(ats_identifier)
        url_ats_api = "#{url_api}#{ats_identifier}/"
        url_ats_main = "#{url_base}#{ats_identifier}/"
        data = get_json_data(url_ats_api)
        return {} unless data

        url_careers, url_website = check_for_careers_url_redirect(url_ats_main)
        {
          name: data['name'],
          description: Flipper.enabled?(:company_description) ? data['content'] : 'Not added yet',
          url_ats_api:,
          url_ats_main:,
          url_careers:,
          url_website:,
          total_live: fetch_total_live(ats_identifier)
        }
      end

      private

      def check_for_careers_url_redirect(ats_url)
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
          redirected_url = URI.parse(response['Location'])
          [redirected_url, redirected_url.host]
        else
          p "No redirect for #{ats_url}"
          nil
        end
      end
    end
  end
end
