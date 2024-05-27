module Importer
  module Api
    # This class is responsible for importing jobs from DevITJobs
    # API Endpoint: https://devitjobs.uk/api/jobsLight
    # To use this: rake admin:devitjobs
    # This works by: (1) fetching JSON from the API, (2) creating a company then job for each DevITJobs job, and (3) handling redirects.
    #
    class DevitJobs < ApplicationService
      include Capybara::DSL
      include CheckUrlIsValid

      def import
        return p "Unable to scrape DevITJobs: first create ATS" unless (@ats = ApplicantTrackingSystem.find_by(name: 'DevITJobs'))

        @redirect_urls = []

        fetch_json_data.each do |job_data|
          next if redirect?(job_data)

          company = @ats.find_or_create_company_by_data(job_data)
          job = @ats.find_or_create_job_by_data(company, job_data)
          p "Created DevITJobs job - #{job.title}"
        end

        p "grabbing jobs with DevIT redirects..."
      end

      private

      def fetch_json_data
        url = @ats.url_all_jobs
        response = get(url)
        JSON.parse(response)
      end

      def redirect?(json_data)
        return false unless json_data['redirectJobUrl']

        @redirect_urls << json_data['redirectJobUrl']
      end
    end
  end
end
