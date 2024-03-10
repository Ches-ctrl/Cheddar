module Ats
  module Ashbyhq
    module CompanyDetails
      extend ActiveSupport::Concern

      def self.get_company_details(url, ats_system, ats_identifier)
        p "Getting AshbyHQ company details - #{url}"

        company_name = ats_identifier.humanize
        company = Company.find_by(company_name:)

        if company
          p "Existing company - #{company.company_name}"
        else
          company = Company.create(
            company_name:,
            ats_identifier:,
            applicant_tracking_system_id: ats_system.id,
            url_ats_api: "#{ats_system.base_url_api}#{ats_identifier}?includeCompensation=true",
            url_ats_main: "#{ats_system.base_url_main}#{ats_identifier}"
          )
          p "Created company - #{company.company_name}" if company.persisted?
        end
        company
      end
    end
  end
end
