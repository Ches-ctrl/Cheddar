module Ats
  module Recruitee
    module CompanyDetails
      def get_company_details(url, ats_system, ats_identifier)
        p "Getting Recruitee company details - #{url}"

        company_name = ats_identifier.capitalize
        company = Company.find_by(company_name:)

        if company
          p "Existing company - #{company.company_name}"
        else
          api_url, main_url = replace_ats_identifier(ats_system, ats_identifier)
          company = Company.create(
            company_name:,
            applicant_tracking_system_id: ats_system.id,
            url_ats_api: api_url,
            url_ats_main: main_url
          )

          p "Created company - #{company.company_name}" if company.persisted?
        end
        company
      end

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
