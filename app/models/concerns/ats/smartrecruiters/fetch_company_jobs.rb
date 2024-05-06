module Ats
  module Smartrecruiters
    module FetchCompanyJobs
      def fetch_company_jobs(ats_identifier)
        endpoint = "#{url_api}#{ats_identifier}/postings"
        get_json_data(endpoint)&.dig('content')
      end
    end
  end
end
