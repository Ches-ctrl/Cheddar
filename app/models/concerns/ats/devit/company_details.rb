module Ats
  module Devit
    module CompanyDetails
      extend AtsMethods
      extend ValidUrl

      # TODO: abstract nearly all of this logic into a concern shared by all ATS modules
      def self.find_or_create(ats_identifier)
        company = Company.find_or_create_by(ats_identifier:) do |new_company|
          ats_system = this_ats
          company_name, description = fetch_company_data(ats_system, ats_identifier)
          return unless company_name

          new_company.company_name = company_name
          new_company.description = description
          new_company.applicant_tracking_system = ats_system
          new_company.url_ats_api = ''
          new_company.url_ats_main = ''
          puts "Created company - #{new_company.company_name}"
        end

        return company
      end

      def self.fetch_company_data(ats_system, ats_identifier)
        company_api_url = "#{ats_system.base_url_api}#{ats_identifier}"
        response = get(company_api_url)
        data = JSON.parse(response)
        [data['name'], data['content']]
      end
    end
  end
end
