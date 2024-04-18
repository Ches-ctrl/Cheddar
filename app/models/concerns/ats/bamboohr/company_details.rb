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

      def fetch_total_live(ats_identifier)
        company_api_url = replace_ats_identifier(ats_identifier).to_s
        p "Company API URL - #{company_api_url}"
        response = get(company_api_url)
        data = JSON.parse(response)
        data.dig('meta', 'totalCount')
      end
    end
  end
end
