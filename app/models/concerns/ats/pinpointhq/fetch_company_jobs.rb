module Ats
  module Pinpointhq
    module FetchCompanyJobs
      def fetch_company_jobs(ats_identifier)
        endpoint = replace_ats_identifier(ats_identifier).first
        get_json_data(endpoint)&.dig('data')
      end
    end
  end
end
