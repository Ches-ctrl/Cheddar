module Importer
  module Api
    # Base class for importing jobs from an API
    class JobApi
      include FaradayHelpers
      # TODO: Add capability to save responses to S3

      def initialize(ats_name)
        @ats = ApplicantTrackingSystem.find_by(name: ats_name)
        @redirect_urls = []
        @date = Date.today.strftime('%Y-%m-%d')
        @local_storage_path = Rails.root.join('public', 'data', @ats.name, @date)
        FileUtils.mkdir_p(@local_storage_path)
        @initial_count = Job.count
      end

      def import_jobs(url)
        p @initial_count

        jobs_data = fetch_local_data || fetch_and_save_remote_data(url)
        return unless jobs_data

        p "Fetched #{jobs_data.count} jobs from #{@ats.name}"

        p jobs_data.first

        process_jobs(jobs_data)
        import_redirects if respond_to?(:import_redirects)

        p "Imported #{Job.count - @initial_count} jobs from #{@ats.name}"
      end

      private

      def fetch_local_data
        file_path = File.join(@local_storage_path, 'jobs.json')
        return unless File.exist?(file_path)

        file = File.read(file_path)
        JSON.parse(file)
      end

      def fetch_and_save_remote_data(url)
        jobs_data = fetch_json(url)
        return unless jobs_data

        save_jobs_data(jobs_data)

        jobs_data
      end

      def save_jobs_data(jobs_data)
        file_path = File.join(@local_storage_path, 'jobs.json')
        File.write(file_path, JSON.pretty_generate(jobs_data))
      end

      def process_jobs(jobs_data)
        jobs_data.each do |job_data|
          next if redirect?(job_data)

          # TODO: Refactor to call CompanyCreator and JobCreator as service classes
          company = @ats.find_or_create_company_by_data(job_data)
          p "Company: #{company.name}"
          job = @ats.find_or_create_job_by_data(company, job_data)
          p "Job: #{job.title}"
        end
      end

      def redirect?(_job_data)
        false
      end
    end
  end
end
