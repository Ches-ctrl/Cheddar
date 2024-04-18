module Ats
  module Bamboohr
    module CompanyDetails
      def company_details(ats_identifier)
        url_ats_api, url_ats_main = replace_ats_identifier(ats_identifier)
        company_name = ats_identifier.capitalize
        {
          company_name:,
          url_ats_api:,
          url_ats_main:
        }
      end

      def replace_ats_identifier(ats_identifier)
        api_url = base_url_api
        main_url = base_url_main

        api_url.gsub!("XXX", ats_identifier)
        main_url.gsub!("XXX", ats_identifier)
        [api_url, main_url]
      end

      def fetch_total_live(ats_identifier)
        company_api_url = replace_ats_identifier(ats_identifier).to_s
        p "Company API URL - #{company_api_url}"
        uri = URI(company_api_url)
        response = Net::HTTP.get(uri)
        data = JSON.parse(response)
        data.dig('meta', 'totalCount')
      end
    end
  end
end
