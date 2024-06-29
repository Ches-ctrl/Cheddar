module Ats
  module JobCreator
    extend ActiveSupport::Concern
    # TODO: Refactor this to simplify down
    # TODO: Refactor into a service object according to the Single Responsibility Principle

    # This checks whether job_data is fetched from a job-specific endpoint.
    # Return false with Lever because its job-specific endpoint gives no additional data on top of
    # what the company endpoint gives.
    def individual_job_endpoint_exists?
      p "Checking if individual job endpoint exists"
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

    def job_url_api(url_api, ats_identifier, ats_job_id)
      refer_to_module(defined?(super) ? super : nil, __method__)
    end

    def job_details(new_job, data)
      refer_to_module(defined?(super) ? super : nil, __method__)
    end

    def fetch_job_data(_job_id, api_url, _ats_identifier)
      get_json_data(api_url)
    end
  end
end
