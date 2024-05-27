module Ats
  module JobCreator
    extend ActiveSupport::Concern
    # TODO: Refactor this to simplify down

    def find_or_create_job_by_data(company, data)
      ats_job_id = fetch_id(data)
      find_or_create_job(company, ats_job_id, data)
    end

    def find_or_create_job(company, ats_job_id, data = nil)
      return unless company&.persisted?

      job = Job.find_or_create_by(ats_job_id:) do |new_job|
        new_job.company = company
        new_job.applicant_tracking_system = self
        new_job.api_url = job_url_api(url_api, company.ats_identifier, ats_job_id)
        data ||= fetch_job_data(new_job)
        return if data.blank? || data['error'].present? || data.values.include?(404)

        job_details(new_job, data)
        fetch_additional_fields(new_job, data)
        puts "Created new job - #{new_job.title} with #{company.name}"
      end

      return job
    end

    # This checks whether job_data is fetched from a job-specific endpoint.
    # Return false with Lever because its job-specific endpoint gives no additional data on top of
    # what the company endpoint gives.
    def individual_job_endpoint_exists?
      return false if name == 'Lever'

      parameters = method(:job_url_api).parameters
      parameters.any? { |param| param[1] == :job_id }
    end

    def fetch_company_jobs(ats_identifier)
      refer_to_module(defined?(super) ? super : nil, __method__)
    end

    def fetch_title_and_location(data)
      refer_to_module(defined?(super) ? super : nil, __method__)
    end

    def mark_job_expired(job)
      p "Job with ID #{job.ats_job_id} is expired."
      job.live = false
      return nil
    end

    private

    def job_details(new_job, data)
      refer_to_module(defined?(super) ? super : nil, __method__)
    end

    def job_url_api(url_api, ats_identifier, ats_job_id)
      refer_to_module(defined?(super) ? super : nil, __method__)
    end

    def fetch_job_data(job)
      get_json_data(job.api_url)
    end

    def fetch_additional_fields(job, data)
      p job
      get_application_criteria(job, data)
      p "Getting form fields for #{job.title}..."
      job.save! # must save before passing to Sidekiq job
      # TODO: create separate module methods for this
      begin
        Importer::GetFormFieldsJob.perform_later(job) if Flipper.enabled?(:get_form_fields)
      rescue StandardError => e
        p "Error getting form fields for #{job.title}: #{e.message}"
      end
    end
  end
end
