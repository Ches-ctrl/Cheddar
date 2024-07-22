module Importer
  module Api
    # Sub-class responsible for importing jobs from DevITJobs
    # API Endpoint: https://devitjobs.uk/api/jobsLight
    # To use this: rake admin:devitjobs
    # This works by: (1) fetching JSON from the API, (2) creating a company then job for each DevITJobs job, and (3) handling redirects.
    class DevitJobs < JobPostingsApi
      def initialize
        @ats = fetch_ats
        super(@ats, api_details, Url::CreateDevitJobFromUrlJob)
      end

      private

      def api_details
        { endpoint: @ats&.url_all_jobs }
      end

      def fetch_ats
        ApplicantTrackingSystem.find_by(name: 'DevITJobs')
      end

      def redirect?(json_data)
        json_data['redirectJobUrl'].present?
      end
    end
  end
end
