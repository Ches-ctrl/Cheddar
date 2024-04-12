module Ats
  module Devitjobs
    module CompanyDetails
      def fetch_company_id(data)
        data['company'].gsub(' ', '-').gsub(/[^A-Za-z\-]/, '')
      end

      def update_company_details(company, data)
        company.company_name = data['company']
        company.company_website_url = data['companyWebsiteLink']
        company.company_category = data['companyType']
        company.location = [data['address'], data['actualCity'], data['postalCode']].reject(&:blank?).join(', ')
        # company.img_url = data['logoImg'].include?('https://') ? data['logoImg'] : "https://static.devitjobs.uk/logo-images/#{data['logoImg']}"
      end
    end
  end
end
