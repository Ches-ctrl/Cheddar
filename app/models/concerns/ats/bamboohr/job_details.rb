module Ats
  module Bamboohr
    module JobDetails
      def fetch_job_data(job, ats)
        job_url_api = job.company.url_ats_api
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

      def job_details(job, data)
        p "Updating job details - #{job.job_title}"

        location = "#{data['location']['city']}, #{data['location']['state']}" if data['location']['city'] && data['location']['state']

        job.update(
          job_title: data['jobOpeningName'],
          department: data['departmentLabel'],
          employment_type: data['employmentStatusLabel'],
          # location:,
          ats_job_id: data['id']
        )
      end

      def job_url_api(_base_url, company_id, _job_id)
        company = Company.find(company_id)
        company.url_ats_api
      end
    end
  end
end
