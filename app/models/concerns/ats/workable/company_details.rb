module Ats
  module Workable
    module CompanyDetails
      def self.find_or_create(_ats_identifier)
        # TODO: add method here
        return
      end

      def self.get_company_details(url, ats_system, ats_identifier)
        p "Getting workable company details - #{url}"

        # TODO: Clarify whether to use company_name as the uniqueness criterion for companies
        # TODO: Add capbilitiy to handle logos, mailbox, etc.

        company_name, _, description = fetch_company_data(ats_system, ats_identifier)
        company = Company.find_by(company_name:)

        if company
          p "Existing company - #{company.company_name}"
          check_for_details(company, ats_system, ats_identifier, description)
        else
          company = Company.create(
            company_name:,
            description:,
            ats_identifier:,
            applicant_tracking_system_id: ats_system.id,
            url_ats_api: "#{ats_system.base_url_api}#{ats_identifier}",
            url_ats_main: "#{ats_system.base_url_main}#{ats_identifier}"
          )
          p "Created company - #{company.company_name}" if company.persisted?
          check_for_careers_url_redirect(company)

          # p "Calling GetAllJobUrls"
          # GetAllJobUrls.new(company).get_all_job_urls if new_company
          # p "Finished GetAllJobUrls"
        end
        company
      end

      def self.fetch_company_data(ats_system, ats_identifier)
        company_api_url = "#{ats_system.base_url_api}#{ats_identifier}"
        uri = URI(company_api_url)
        response = Net::HTTP.get(uri)
        data = JSON.parse(response)
        [data['name'], data['url'], data['details']['overview']['description']]
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

      def self.check_for_careers_url_redirect(company)
      end
    end
  end
end
