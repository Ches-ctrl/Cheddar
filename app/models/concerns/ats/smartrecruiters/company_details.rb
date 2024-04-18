module Ats
  module Smartrecruiters
    module CompanyDetails
      def company_details(ats_identifier)
        # NB: job_details will update company_name and industry from job data
        company_name = ats_identifier.capitalize
        {
          company_name:,
          url_ats_api: "#{base_url_api}#{ats_identifier}/postings",
          url_ats_main: "#{base_url_main}#{ats_identifier}"
        }
      end

      def fetch_total_live(ats_identifier)
        company_api_url = "#{base_url_api}#{ats_identifier}/postings"
        response = get(company_api_url)
        data = JSON.parse(response)
        data['totalFound']
      end
    end
  end
end
