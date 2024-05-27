module Importer
  module Api
    # Base class for importing jobs from an API
    class JobApi < ApplicationService
      def initialize(ats_name)
        @ats = ApplicantTrackingSystem.find_by(name: ats_name)
        @redirect_urls = []
      end

      def import_jobs
        jobs_data = fetch_json(@ats.url_all_jobs)
        return unless jobs_data

        p "Fetched #{jobs_data.count} jobs from #{@ats.name}"

        process_jobs(jobs_data)
        import_redirects if respond_to?(:import_redirects)
      end

      private

      def process_jobs(jobs_data)
        jobs_data.each do |job_data|
          next if redirect?(job_data)

          company = @ats.find_or_create_company_by_data(job_data)
          @ats.find_or_create_job_by_data(company, job_data)
        end
      end

      def redirect?(_job_data)
        false
      end
    end
  end
end
