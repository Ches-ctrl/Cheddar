module Ats
  module Devitjobs
    module CompanyDetails
      def fetch_company_id(data)
        p "Fetching company ID"
        data['company'].gsub(' ', '-').gsub(/[^A-Za-z\-]/, '')
      end

      def company_details(ats_identifier)
        p "Fetching company details"
        {
          url_ats_api: "https://devitjobs.uk/api/companyPages/#{ats_identifier}",
          url_ats_main: "https://devitjobs.uk/companies/#{ats_identifier}",
          total_live: fetch_total_live(ats_identifier)
        }
      end

      def company_details_from_data(data)
        p "Fetching company details from data"
        {
          name: data['company'],
          url_website: data['companyWebsiteLink'],
          industry: data['companyType'],
          location: [data['address'], data['actualCity'], data['postalCode']].reject(&:blank?).join(', '),
          description: Flipper.enabled?(:company_description) ? data['content'] : 'Not added yet'
          # img_url: data['logoImg'].include?('https://') ? data['logoImg'] : "https://static.devitjobs.uk/logo-images/#{data['logoImg']}"
        }
      end
    end
  end
end
