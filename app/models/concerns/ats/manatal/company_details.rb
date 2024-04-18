module Ats
  module Manatal
    module CompanyDetails
      private

      def company_details(ats_identifier)
        url_ats_api = "#{base_url_api}#{ats_identifier}"
        response = get(url_ats_api)
        data = JSON.parse(response)
        {
          company_name: data['name'],
          url_ats_api:,
          url_ats_main: "#{base_url_main}#{ats_identifier}",
          description: data['description'],
          company_website_url: data['website'],
          total_live: fetch_total_live(ats_identifier)
          # facebook: data['facebook_url'],
          # linkedin: data['linkedin_url'],
        }
      end

      def fetch_total_live(ats_identifier)
        company_api_url = "#{base_url_api}#{ats_identifier}/jobs/"
        response = get(company_api_url)
        data = JSON.parse(response)
        data['count']
      end
    end
  end
end
