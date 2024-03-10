module Ats
  module Recruitee
    module JobDetails
      extend ActiveSupport::Concern

      def self.get_job_details(job)
        ats = job.company.applicant_tracking_system
        data = fetch_job_data(job, ats)
        update_job_details(job, data)
        p "Updated job details - #{job.job_title}"
        job
      end

      def self.fetch_job_data(job, _ats)
        job_url_api = job.company.url_ats_api.to_s
        p "Fetching job data - #{job_url_api}"
        job.api_url = job_url_api
        job_apply_url = "#{job.company.url_ats_main}o/#{job.ats_job_id}/c/new"
        p "Job apply URL - #{job_apply_url}"

        uri = URI(job_url_api)
        response = Net::HTTP.get(uri)
        all_jobs_data = JSON.parse(response)
        data = all_jobs_data["offers"].find { |job| job["careers_apply_url"] == job_apply_url }

        return data if data

        p "Job with ID #{job.ats_job_id} is expired."
        job.live = false
        return nil
      end

      def self.update_job_details(job, data)
        p "Updating job details - #{job.job_title}"

        job.update(
          job_title: data['title'],
          job_description: data['description'],
          department: data['departmentLabel'],
          employment_type: data['employment_type_code'],
          country: data['country'],
          location: data['location'],
          ats_job_id: data['id']
        )
      end
    end
  end
end
