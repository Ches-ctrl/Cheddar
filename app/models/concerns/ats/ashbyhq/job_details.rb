module Ats
  module Ashbyhq
    module JobDetails
      # TODO: Check if job already exists in database
      # TODO: Update job to handle workplace (hybrid)
      # TODO: Update description to handle html and non-html, add labelling for this characteristic

      def find_or_create_by_id(_company, _ats_job_id)
        return
      end

      def get_job_details(job)
        ats = job.company.applicant_tracking_system
        data = fetch_job_data(job, ats)
        update_job_details(job, data) if job.live
        p "Updated job details - #{job.job_title}"
        job
      end

      def fetch_job_data(job, _ats)
        job_url_api = "#{job.company.url_ats_api}?includeCompensation=true"
        job.api_url = job_url_api
        job_id = job.ats_job_id

        uri = URI(job_url_api)
        response = Net::HTTP.get(uri)
        all_jobs_data = JSON.parse(response)
        data = all_jobs_data["jobs"].find { |job| job["id"] == job_id }

        return data if data

        p "Job with ID #{job.ats_job_id} is expired."
        job.live = false
        return nil
      end

      def update_job_details(job, data)
        job.update(
          job_title: data['title'],
          job_description: data['descriptionHtml'],
          office_status: data['remote'] ? 'Remote' : 'On-site',
          location: data['location'],
          country: data['address']['addressCountry'],
          department: data['department']
        )
      end
    end
  end
end
