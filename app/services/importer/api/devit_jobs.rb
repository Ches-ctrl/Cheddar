module Importer
  module Api
    # Sub-class responsible for importing jobs from DevITJobs
    # API Endpoint: https://devitjobs.uk/api/jobsLight
    # To use this: rake admin:devitjobs
    # This works by: (1) fetching JSON from the API, (2) creating a company then job for each DevITJobs job, and (3) handling redirects.
    class DevitJobs < JobApi
      def initialize
        super('DevITJobs')
      end

      private

      def redirect?(json_data)
        return false unless json_data['redirectJobUrl']

        @redirect_urls << json_data['redirectJobUrl']
      end

      def import_redirects
        p @redirect_urls.count
        # @redirect_urls.each do |url|
        #   # TODO: Add handling for redirected urls
        #   URL::CreateJobFromUrl.new(url).create_company_then_job
        # end
      end
    end
  end
end
