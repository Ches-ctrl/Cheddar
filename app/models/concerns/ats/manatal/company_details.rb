module Ats
  module Manatal
    module CompanyDetails
      private

      def company_details(ats_identifier)
        url_ats_api = "#{url_api}#{ats_identifier}/"
        data = get_json_data(url_ats_api)
        return {} unless data

        {
          name: data['name'],
          url_ats_api:,
          url_ats_main: "#{url_base}#{ats_identifier}",
          description: data['description'],
          url_website: data['website'],
          total_live: fetch_total_live(ats_identifier)
          # facebook: data['facebook_url'],
          # linkedin: data['linkedin_url'],
        }
      end

      def fetch_total_live(ats_identifier)
        # This method supersedes the generic one as it's more efficient
        company_api_url = "#{url_api}#{ats_identifier}/jobs/"
        data = get_json_data(company_api_url)
        data['count']
      end
    end
  end
end
