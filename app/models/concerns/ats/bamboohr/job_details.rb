module Ats
  module Bamboohr
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
        job.api_url = job_url_api
        job_id = job.ats_job_id

        uri = URI(job_url_api)
        response = Net::HTTP.get(uri)
        all_jobs_data = JSON.parse(response)
        data = all_jobs_data["result"].find { |job| job["id"] == job_id }

        return data if data

        p "Job with ID #{job.ats_job_id} is expired."
        job.live = false
        return nil
      end

      def self.update_job_details(job, data)
        p "Updating job details - #{job.job_title}"

        location = "#{data['location']['city']}, #{data['location']['state']}" if data['location']['city'] && data['location']['state']

        job.update(
          job_title: data['jobOpeningName'],
          department: data['departmentLabel'],
          employment_type: data['employmentStatusLabel'],
          location:,
          ats_job_id: data['id']
        )
      end
    end
  end
end
