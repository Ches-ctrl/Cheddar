module Ats
  module Lever
    module FetchCompanyJobs
      def fetch_company_jobs(company)
        endpoint = "#{company.url_ats_api}/jobs"
        data = get_json_data(endpoint)
        return data
      end
    end
  end
end
