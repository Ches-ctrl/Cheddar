module Ats
  module Ashbyhq
    module FetchCompanyJobs
      def fetch_company_jobs(ats_identifier)
        endpoint = "#{url_api}#{ats_identifier}?includeCompensation=true"
        data = get_json_data(endpoint)
        return data['jobs']
      end
    end
  end
end
