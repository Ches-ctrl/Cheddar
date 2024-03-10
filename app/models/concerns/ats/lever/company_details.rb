module Ats
  module Lever
    module CompanyDetails
      extend ActiveSupport::Concern

      def self.get_company_details(url, ats_system, ats_identifier)
        p "Getting lever company details - #{url}"

        # TODO: Update to scrape company details given lack of API endpoint for company information
        # TODO: Add total live based on total number of jobs returned by API call (for each ATS system)

        company_name = ats_identifier.capitalize
        company = Company.find_by(company_name:)

        if company
          p "Existing company - #{company.company_name}"
        else
          company = Company.create(
            company_name:,
            ats_identifier:,
            applicant_tracking_system_id: ats_system.id,
            url_ats_api: "#{ats_system.base_url_api}#{ats_identifier}",
            url_ats_main: "#{ats_system.base_url_main}#{ats_identifier}"
          )
          p "Created company - #{company.company_name}" if company.persisted?

          # p "Calling GetAllJobUrls"
          # GetAllJobUrls.new(company).get_all_job_urls if new_company
          # p "Finished GetAllJobUrls"

          # TODO: Handle logic for GetAllJobUrls via web scrape or API call depending on ATS system
        end
        company
      end
    end
  end
end
