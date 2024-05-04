module Ats
  module Bamboohr
    module CompanyDetails
      private

      def company_details(ats_identifier)
        url_ats_api, url_ats_main = replace_ats_identifier(ats_identifier)
        data = fetch_company_api_data(url_ats_main)
        {
          name: data['name'],
          url_ats_api:,
          url_ats_main:,
          total_live: fetch_total_live(url_ats_api)
        }
      end

      def fetch_total_live(url_ats_api)
        p "Company API URL - #{url_ats_api}"

        data = get_json_data(url_ats_api)
        data.dig('meta', 'totalCount')
      end

      def fetch_company_api_data(url_ats_main)
        endpoint = "#{url_ats_main}company-info"
        get_json_data(endpoint)
      end
    end
  end
end
