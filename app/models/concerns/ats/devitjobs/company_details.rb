module Ats
  module Devitjobs
    module CompanyDetails
      private

      def fetch_company_id(data)
        data['company'].gsub(' ', '-').gsub(/[^A-Za-z\-]/, '')
      end

      def company_details(ats_identifier)
        {
          url_ats_api: "https://devitjobs.uk/api/companyPages/#{ats_identifier}",
          url_ats_main: "https://devitjobs.uk/companies/#{ats_identifier}",
          total_live: fetch_total_live(ats_identifier)
        }
      end

      def company_details_from_data(data)
        {
          name: data['company'],
          url_website: data['companyWebsiteLink'],
          industry: data['companyType'],
          location: [data['address'], data['actualCity'], data['postalCode']].reject(&:blank?).join(', '),
          description: data['content']
          # img_url: data['logoImg'].include?('https://') ? data['logoImg'] : "https://static.devitjobs.uk/logo-images/#{data['logoImg']}"
        }
      end
    end
  end
end
