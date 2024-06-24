module Importer
  module Api
    # Base class for importing jobs from an external API e.g. jobs board, ATS
    # Uses FaradayHelpers to fetch JSON data
    # First checks if data is saved locally, if not fetches from remote API to save on API calls
    # Works by (1) importing jobs hosted on the ATS (2) importing jobs hosted on other ATS systems
    class JobPostingsApi
      include FaradayHelpers
      # TODO: Add capability to save responses to S3

      def initialize(ats_name)
        @ats = ApplicantTrackingSystem.find_by(name: ats_name)
        @local_storage = LocalDataStorage.new(ats_name)
        set_initial_counts
      end

      def import_jobs(url)
        log_initial_counts

        return unless (jobs_data = fetch_data(url))

        sort_by_hosted(jobs_data)
        log_fetched_jobs_data(jobs_data)

        process_jobs
        log_final_counts
      end

      private

      def set_initial_counts
        @initial_companies = Company.count
        @initial_jobs = Job.count
      end

      def fetch_data(url)
        @local_storage.fetch_local_data || fetch_and_save_remote_data(url)
      end

      def fetch_and_save_remote_data(url)
        jobs_data = fetch_json(url)
        return unless jobs_data

        save_jobs_data(jobs_data)

        jobs_data
      end

      def save_jobs_data(jobs_data)
        @local_storage.save_jobs_data(jobs_data)
      end

      def sort_by_hosted(jobs_data)
        # TODO: Fix JSON parsing error
        parsed_jobs_data = JSON.parse(jobs_data)
        @redirect_jobs, @hosted_jobs = parsed_jobs_data.partition { |job_data| redirect?(job_data) }
      end

      # def redirect?(_job_data)
      #   false
      # end

      def count_redirects
        @redirect_jobs.count
      end

      def process_jobs
        @hosted_jobs.each { |job_data| p "testing processing" }
        p @hosted_jobs.count
        p "Hosted jobs processed."
        @redirect_jobs.each { |job_data| p "testing processing" }
        p @redirect_jobs.count
        p "Redirected jobs processed."
      end

      def create_company_and_job(job_data)
        # TODO: Refactor to call CompanyCreator and JobCreator as service classes
        company = @ats.find_or_create_company_by_data(job_data)
        p "Company: #{company.name}"
        job = @ats.find_or_create_job_by_data(company, job_data)
        p "Job: #{job.title}"
      rescue StandardError => e
        Rails.logger.error "Error creating company and job: #{e.message}"
      end

      def log_initial_counts
        p "Initial companies: #{@initial_companies}"
        p "Initial jobs: #{@initial_jobs}"
      end

      def log_fetched_jobs_data(jobs_data)
        p "Fetched #{jobs_data.count} jobs from #{@ats.name}"
        log_redirects
      end

      def log_redirects
        no_of_redirect_jobs = count_redirects
        p "Redirected links: #{no_of_redirect_jobs}"
      end

      def log_final_counts
        p "Imported #{Company.count - @initial_companies} companies from #{@ats.name}"
        p "Imported #{Job.count - @initial_jobs} jobs from #{@ats.name}"
      end
    end
  end
end
