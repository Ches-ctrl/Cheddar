module Ats
  module Lever
    module FetchCompanyJobs
      def fetch_company_jobs(ats_identifier)
        company_api_url = "#{url_api}#{ats_identifier}?mode=json"
        return unless (response = get(company_api_url))

        return JSON.parse(response)
      end
    end
  end
end
