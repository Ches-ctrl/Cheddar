module Ats
  module Greenhouse
    module CompanyDetails
      def find_or_create_company(ats_identifier)
        company = Company.find_or_create_by(ats_identifier:) do |new_company|
          company_name, description = fetch_company_data(ats_identifier)
          return unless company_name

          new_company.company_name = company_name
          new_company.description = description
          new_company.applicant_tracking_system = self
          new_company.url_ats_api = "#{base_url_api}#{ats_identifier}"
          new_company.url_ats_main = "#{base_url_main}#{ats_identifier}"
          check_for_careers_url_redirect(new_company)
        end

        return company
      end

      def fetch_company_data(ats_identifier)
        company_api_url = "#{base_url_api}#{ats_identifier}"
        response = get(company_api_url)
        data = JSON.parse(response)
        [data['name'], data['content']]
      end

      def check_for_careers_url_redirect(company)
        url = URI(company.url_ats_main)
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
          company.update(url_careers: redirected_url)
          company.update(company_website_url: redirected_url.host)
        else
          p "No redirect for #{company.url_ats_main}"
        end
      end
    end
  end
end
