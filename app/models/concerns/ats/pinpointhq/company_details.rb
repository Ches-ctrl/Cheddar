module Ats
  module Pinpointhq
    module CompanyDetails
      def get_company_details(url, ats_system, ats_identifier)
        p "Getting PinpointHQ company details - #{url}"

        company_name = ats_identifier.capitalize
        company = Company.find_by(company_name:)

        if company
          p "Existing company - #{company.company_name}"
        else
          api_url, main_url = replace_ats_identifier(ats_system, ats_identifier)
          company = Company.create(
            company_name:,
            ats_identifier:,
            applicant_tracking_system_id: ats_system.id,
            url_ats_api: api_url,
            url_ats_main: main_url
          )

          p "Created company - #{company.company_name}" if company.persisted?
        end
        company
      end

      # TODO: Move this to main ATS model as common to multiple ATS systems

      def replace_ats_identifier(ats_system, ats_identifier)
        api_url = ats_system.base_url_api
        main_url = ats_system.base_url_main

        api_url.gsub!("XXX", ats_identifier)
        main_url.gsub!("XXX", ats_identifier)
        [api_url, main_url]
      end
    end
  end
end
