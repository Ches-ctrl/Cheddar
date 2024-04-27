module Ats
  module Greenhouse
    module FetchCompanyJobs
      def fetch_company_jobs(ats_identifier)
        company_api_url = "#{url_api}#{ats_identifier}/jobs"
        data = get_json_data(company_api_url)
        return data['jobs']
      end
    end
  end
end
