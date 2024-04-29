module Ats
  module Bamboohr
    module FetchCompanyJobs
      def fetch_company_jobs(ats_identifier)
        endpoint = replace_ats_identifier(ats_identifier).first
        data = get_json_data(endpoint)
        return data['result']
      end
    end
  end
end
