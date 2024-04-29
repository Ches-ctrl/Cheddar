module Ats
  module Lever
    module FetchCompanyJobs
      def fetch_company_jobs(company)
        endpoint = "#{company.url_ats_api}/jobs"
        get_json_data(endpoint)
      end
    end
  end
end
