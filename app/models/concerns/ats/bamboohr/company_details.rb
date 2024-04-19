module Ats
  module Bamboohr
    module CompanyDetails
      private

      def company_details(ats_identifier)
        url_ats_api, url_ats_main = replace_ats_identifier(ats_identifier)
        company_name = ats_identifier.capitalize
        {
          company_name:,
          url_ats_api:,
          url_ats_main:,
          total_live: fetch_total_live(ats_identifier)
        }
      end

      def fetch_total_live(ats_identifier)
        company_api_url = replace_ats_identifier(ats_identifier).first
        p "Company API URL - #{company_api_url}"
        response = get(company_api_url)
        data = JSON.parse(response)
        data.dig('meta', 'totalCount')
      end
    end
  end
end
