module Ats
  module Workable
    module FetchCompanyJobs
      def fetch_company_jobs(ats_identifier)
        endpoint = "#{url_website}api/accounts/#{ats_identifier}?details=true"
        data = get_json_data(endpoint)
        data['jobs']
      end
    end
  end
end
