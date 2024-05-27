module Importer
  module Api
    # This class is responsible for importing jobs from DevITJobs
    # API Endpoint: https://devitjobs.uk/api/jobsLight
    # To use this: rake admin:devitjobs
    # This works by: (1) fetching JSON from the API, (2) creating a company then job for each DevITJobs job, and (3) handling redirects.
    # TODO: this can all be parsed out into a standard import class for all API-driven job boards / ATSs as they will all follow the same structure
    # TODO: this will make the code more readable and remove the need for duplicate error handling everywhere
    # TODO: Question whether that class is generalised to all API handling or just jobs
    class DevitJobs < ApplicationService
      def initialize
        @ats = ApplicantTrackingSystem.find_by(name: 'DevITJobs')
        @redirect_urls = []
      end

      def import_jobs
        jobs_data = fetch_jobs_data
        return unless jobs_data

        process_jobs(jobs_data)

        p @redirect_urls.count
        # import_redirects
      end

      private

      def fetch_jobs_data
        jobs_data = Faraday.get(@ats.url_all_jobs).body
        JSON.parse(jobs_data)
      rescue Faraday::Error => e
        Rails.logger.error "HTTP request failed: #{e.message}"
      rescue JSON::ParserError => e
        Rails.logger.error "Failed to parse JSON: #{e.message}"
      rescue StandardError => e
        Rails.logger.error "An unexpected error occurred: #{e.message}"
      end

      def process_jobs(jobs_data)
        jobs_data.each do |job_data|
          next if redirect?(job_data)

          company = create_company(job_data)
          create_job(company, job_data)
        end
      end

      def create_company(job_data)
        @ats.find_or_create_company_by_data(job_data).tap do |company|
          Rails.logger.info "Created DevITJobs company - #{company.name}"
        end
      rescue StandardError => e
        p "Error creating DevITJobs company: #{e.message}"
      end

      def create_job(company, job_data)
        @ats.find_or_create_job_by_data(company, job_data).tap do |job|
          Rails.logger.info "Created DevITJobs job - #{job.title} at #{company.name}"
        end
      rescue StandardError => e
        p "Error creating DevITJobs job: #{e.message}"
      end

      def import_redirects
        @redirect_urls.each do |url|
          # TODO: this needs to work out what ATS the other job is from before this can be put into action
          URL::CreateJobFromUrl.new(url).create_company_then_job
        end
      end

      def redirect?(json_data)
        return false unless json_data['redirectJobUrl']

        @redirect_urls << json_data['redirectJobUrl']
      end
    end
  end
end
