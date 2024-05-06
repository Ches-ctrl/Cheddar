module Ats
  module Recruitee
    module FetchCompanyJobs
      def fetch_company_jobs(ats_identifier)
        endpoint = replace_ats_identifier(ats_identifier).first
        get_json_data(endpoint)&.dig('offers')
      end
    end
  end
end
