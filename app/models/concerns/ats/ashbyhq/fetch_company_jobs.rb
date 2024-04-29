module Ats
  module Ashbyhq
    module FetchCompanyJobs
      private

      def fetch_company_jobs(company)
        endpoint = company.url_ats_api
        data = get_json_data(endpoint)
        return data['jobs']
      end
    end
  end
end
