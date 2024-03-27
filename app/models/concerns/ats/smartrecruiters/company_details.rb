module Ats
  module Smartrecruiters
    module CompanyDetails
      def self.find_or_create(_ats_identifier)
        # TODO: add method here
        return
      end

      def self.get_company_details(url, ats_system, ats_identifier)
        p "Getting smartrecruiters company details - #{url}"

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

          company.total_live = fetch_total_live(ats_system, ats_identifier)
          # p "Total live - #{company.total_live}"

          p "Created company - #{company.company_name}" if company.persisted?

          # p "Calling GetAllJobUrls"
          # GetAllJobUrls.new(company).get_all_job_urls if new_company
          # p "Finished GetAllJobUrls"

          # TODO: Handle logic for GetAllJobUrls via web scrape or API call depending on ATS system
        end
        company
      end

      def self.fetch_total_live(ats_system, ats_identifier)
        company_api_url = "#{ats_system.base_url_api}#{ats_identifier}/postings"
        uri = URI(company_api_url)
        response = Net::HTTP.get(uri)
        data = JSON.parse(response)
        data['totalFound']
      end

      # TODO: Add fetch company description off first job posting if there
    end
  end
end
