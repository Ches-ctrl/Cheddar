module Ats
  module Lever
    module FetchCompanyJobs
      def fetch_company_jobs(ats_identifier)
        endpoint = "#{url_api}#{ats_identifier}/?mode=json"
        get_json_data(endpoint)
      end
    end
  end
end
