module Ats
  module Greenhouse
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
          new_company.url_ats_api = "#{ats_system.base_url_api}#{ats_identifier}"
          new_company.url_ats_main = "#{ats_system.base_url_main}#{ats_identifier}"
          check_for_careers_url_redirect(new_company)
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

      def self.check_for_details(company, ats_system, ats_identifier, description)
        if company.description.nil?
          p "Missing description for #{company.company_name}"
          company.update(description:)
        end

        if company.ats_identifier.nil?
          p "Missing ATS identifier for #{company.company_name}"
          company.update(ats_identifier:)
        end

        if company.applicant_tracking_system_id.nil?
          p "Missing ATS system for #{company.company_name}"
          company.update(applicant_tracking_system_id: ats_system.id)
        end

        if company.url_ats_api.nil?
          p "Missing ATS API URL for #{company.company_name}"
          company.update(url_ats_api: "#{ats_system.base_url_api}#{ats_identifier}")
        end

        return unless company.url_ats_main.nil?

        p "Missing ATS Main URL for #{company.company_name}"
        company.update(url_ats_main: "#{ats_system.base_url_main}#{ats_identifier}")
      end
    end
  end
end
