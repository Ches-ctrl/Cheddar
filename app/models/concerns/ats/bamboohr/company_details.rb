module Ats
  module Bamboohr
    module CompanyDetails
      def find_or_create_company(_ats_identifier)
        # TODO: add method here
        return
      end

      def get_company_details(url, ats_system, ats_identifier)
        p "Getting Bamboohr company details - #{url}"

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

          company.total_live = fetch_total_live(company, ats_identifier)
          p "Total live - #{company.total_live}"

          p "Created company - #{company.company_name}" if company.persisted?

          # p "Calling GetAllJobUrls"
          # GetAllJobUrls.new(company).get_all_job_urls if new_company
          # p "Finished GetAllJobUrls"

          # TODO: Handle logic for GetAllJobUrls via web scrape or API call depending on ATS system
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

      def fetch_total_live(company, _ats_identifier)
        company_api_url = company.url_ats_api.to_s
        p "Company API URL - #{company_api_url}"
        uri = URI(company_api_url)
        response = Net::HTTP.get(uri)
        data = JSON.parse(response)
        data['meta']['totalCount']
      end
    end
  end
end
