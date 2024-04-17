module Ats
  module Lever
    module CompanyDetails
      def company_details(ats_identifier)
        url_ats_api = "#{base_url_api}#{ats_identifier}/?mode=json"
        url_ats_main = "#{base_url_main}#{ats_identifier}"
        response = get(url_ats_api)
        data = JSON.parse(response)
        {
          company_name: fetch_company_name(ats_identifier),
          description: data.dig(0, 'additionalPlain'),
          url_ats_api:,
          url_ats_main:
        }
      end

      private

      def fetch_company_name(ats_identifier)
        url = "https://autocomplete.clearbit.com/v1/companies/suggest?query=#{ats_identifier}"
        response = get(url)
        data = JSON.parse(response)
        return data.dig(0, 'name') unless data.blank?
      end
    end
  end
end
