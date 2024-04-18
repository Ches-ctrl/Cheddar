module Ats
  module Greenhouse
    module FetchCompanyJobs
      include CheckUrlIsValid

      def fetch_company_jobs(ats_identifier)
        company_api_url = "#{base_url_api}#{ats_identifier}/jobs"
        return unless (response = get(company_api_url))

        data = JSON.parse(response)
        return data['jobs']
      end
    end
  end
end
