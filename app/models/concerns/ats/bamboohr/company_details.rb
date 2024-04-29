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
          total_live: fetch_total_live(url_ats_api)
        }
      end

      def fetch_total_live(url_ats_api)
        p "Company API URL - #{url_ats_api}"

        data = get_json_data(url_ats_api)
        data.dig('meta', 'totalCount')
      end
    end
  end
end
