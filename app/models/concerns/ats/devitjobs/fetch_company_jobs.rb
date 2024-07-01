module Ats
  module Devitjobs
    module FetchCompanyJobs
      extend ActiveSupport::Concern
      include CheckUrlIsValid

      def fetch_company_jobs(ats_identifier)
        p "Fetching company jobs"
        data = get_json_data(url_all_jobs)
        data.select { |job_data| job_data['jobUrl'].include?(ats_identifier) }
      end
    end
  end
end
