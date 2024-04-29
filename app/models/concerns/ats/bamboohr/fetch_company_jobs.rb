module Ats
  module Bamboohr
    module FetchCompanyJobs
      private

      def fetch_company_jobs(company)
        endpoint = company.url_ats_api
        data = get_json_data(endpoint)
        return data['result']
      end
    end
  end
end
