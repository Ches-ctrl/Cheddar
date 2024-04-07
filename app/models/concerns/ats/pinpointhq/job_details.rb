module Ats
  module Pinpointhq
    module JobDetails
      def get_job_details(job)
        ats = job.company.applicant_tracking_system
        data = fetch_job_data(job, ats)
        update_job_details(job, data)
        p "Updated job details - #{job.job_title}"
        job
      end

      def self.fetch_job_data(job, _ats)
        job_url_api = "#{job.company.url_ats_api}postings.json"
        job.api_url = job_url_api
        job_id = job.ats_job_id

        uri = URI(job_url_api)
        response = Net::HTTP.get(uri)
        all_jobs_data = JSON.parse(response)
        data = all_jobs_data["data"].find { |job| job["path"] == "/en/postings/#{job_id}" }

        return data if data

        p "Job with ID #{job.ats_job_id} is expired."
        job.live = false
        return nil
      end

      def self.update_job_details(job, data)
        p "Updating job details - #{job.job_title}"

        job.update(
          job_title: data['name'],
          job_description: data['description'],
          country: data['location']['name'],
          department: data['job']['department']['name'],
          requirements: data['skills_knowledge_requirements'],
          responsibilities: data['key_responsibilities'],
          date_created: data['releasedDate'],
          benefits: data['benefits'],
          ats_job_id: data['id']
        )
      end
    end
  end
end
