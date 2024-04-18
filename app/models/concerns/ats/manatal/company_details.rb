module Ats
  module Manatal
    module CompanyDetails
      include CheckUrlIsValid

      def company_details(ats_identifier)
        url_ats_api = "#{base_url_api}#{ats_identifier}"
        response = get(url_ats_api)
        data = JSON.parse(response)
        {
          company_name: data['name'],
          url_ats_api:,
          url_ats_main: "#{base_url_main}#{ats_identifier}",
          description: data['description'],
          company_website_url: data['website']
          # facebook: data['facebook_url'],
          # linkedin: data['linkedin_url'],
        }
      end

      def fetch_total_live(ats_identifier)
        company_api_url = "#{base_url_api}#{ats_identifier}/jobs/"
        uri = URI(company_api_url)
        response = Net::HTTP.get(uri)
        data = JSON.parse(response)
        data['count']
      end
    end
  end
end
