module Ats
  module Bamboohr
    module CompanyDetails
      def company_details(ats_identifier)
        url_ats_api, url_ats_main = replace_ats_identifier(ats_identifier)
        data = fetch_company_api_data(url_ats_main)
        return {} unless data

        {
          name: data['name'],
          url_ats_api:,
          url_ats_main:,
          total_live: fetch_total_live(ats_identifier)
        }
      end

      private

      def fetch_company_api_data(url_ats_main)
        endpoint = "#{url_ats_main}company-info/"
        data = get_json_data(endpoint)
        data&.dig('result')
      end
    end
  end
end
