module Ats
  module Workable
    module FetchCompanyJobs
      def fetch_company_jobs(ats_identifier)
        company_uid = fetch_company_uid(ats_identifier)
        fetch_jobs_with_uid(company_uid)
      end

      private

      def fetch_company_uid(ats_identifier)
        endpoint = "#{url_api}#{ats_identifier}"
        company_data = get_json_data(endpoint, use_proxy: true)
        company_data['uid']
      end

      def fetch_jobs_with_uid(company_uid)
        endpoint = "#{url_all_jobs}api/v1/companies/#{company_uid}"
        get_json_data(endpoint, use_proxy: true)&.dig('jobs')
      end
    end
  end
end
