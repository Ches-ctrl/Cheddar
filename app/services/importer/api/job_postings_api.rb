# frozen_string_literal: true

module Importer
  module Api
    # Base class for importing jobs from an external API e.g. jobs board, ATS
    # Uses FaradayHelpers to fetch JSON data
    # First checks if data is saved locally, if not fetches from remote API to save on API calls
    # Works by (1) importing jobs hosted on the ATS (2) importing jobs hosted on other ATS systems
    class JobPostingsApi < ApplicationTask
      include FaradayHelpers
      # TODO: Add capability to save responses to S3

      def initialize(ats, api_details, redirect_processor)
        @ats = ats
        @api_details = api_details
        @redirect_processor = redirect_processor
        @local_storage = LocalDataStorer.new(@ats.name)
        set_initial_counts
      end

      def call
        return false unless processable

        process
      end

      private

      def processable
        @ats.present? && @api_details.present?
      end

      def process
        log_initial_counts

        return unless (jobs_data = fetch_jobs_data)

        sort_by_hosted(jobs_data)
        log_fetched_jobs_data(jobs_data)

        process_jobs
        log_final_counts
      end

      def count_redirects
        @redirect_jobs.count
      end

      def create_company_and_job(job_data)
        company = CompanyCreator.call(ats: @ats, data: job_data)
        p "Company: #{company&.name}"
        job = JobCreator.call(ats: @ats, company:, data: job_data)
        p "Job: #{job&.title}"
      end

      def extract_jobs_from_data
        @data
      end

      def fetch_jobs_data
        @data = @local_storage.fetch_local_data || fetch_and_save_remote_data
        extract_jobs_from_data
      end

      def fetch_and_save_remote_data
        jobs_data = faraday_request(@api_details)
        return unless jobs_data

        save_jobs_data(jobs_data)

        jobs_data
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

      def process_jobs
        process_hosted_jobs
        process_redirect_jobs
      end

      def process_hosted_jobs
        @hosted_jobs.each { |job_data| create_company_and_job(job_data) }
        p @hosted_jobs.count
        p "Hosted jobs processed."
      end

      def process_redirect_jobs
        @redirect_jobs.each { |job_data| @redirect_processor.perform_later(job_data) }
        p @redirect_jobs.count
        p "Redirected jobs processed."
      end

      # def redirect?(_job_data)
      #   false
      # end

      def save_jobs_data(jobs_data)
        @local_storage.save_jobs_data(jobs_data)
      end

      def set_initial_counts
        @initial_companies = Company.count
        @initial_jobs = Job.count
      end

      def sort_by_hosted(jobs_data)
        @redirect_jobs, @hosted_jobs = jobs_data.partition { |job_data| redirect?(job_data) }
      end
    end
  end
end
