module Importer
  module Api
    # Sub-class responsible for importing jobs from DevITJobs
    # API Endpoint: https://devitjobs.uk/api/jobsLight
    # To use this: rake admin:devitjobs
    # This works by: (1) fetching JSON from the API, (2) creating a company then job for each DevITJobs job, and (3) handling redirects.
    class TrueupJobs < JobPostingsApi
      def initialize
        super('TrueUp', Url::CreateTrueupJobFromUrlJob)
      end

      def call
        super(@ats.url_all_jobs)
      end

      private

      def redirect?(_json_data)
        true
      end
    end
  end
end
