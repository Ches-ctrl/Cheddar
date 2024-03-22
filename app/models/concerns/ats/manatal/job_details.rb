module Ats
  module Manatal
    module JobDetails
      extend ActiveSupport::Concern

      def self.find_or_create_by_id(_company, _ats_job_id)
        return
      end

      def self.get_job_details(job)
        ats = job.company.applicant_tracking_system
        data = fetch_job_data(job, ats)
        update_job_details(job, data)
        p "Updated job details - #{job.job_title}"
        job
      end

      def self.fetch_job_data(job, ats)
        job_url_api = "#{ats.base_url_api}#{job.company.ats_identifier}/jobs/"
        p "Fetching job data - #{job_url_api}"

        page = 1
        loop do
          uri = URI("#{job_url_api}?page=#{page}")
          response = Net::HTTP.get(uri)
          all_jobs_data = JSON.parse(response)
          jobs = all_jobs_data["results"]

          data = jobs.find { |job_data| job_data["hash"] == job.ats_job_id }

          if data
            p data
            job.api_url = "#{job_url_api}#{data['id']}"
            return data
          end

          if all_jobs_data["next"].nil?
            p "Job with ID #{job.ats_job_id} is expired."
            job.live = false
            return nil
          else
            page += 1
          end
        end
      end

      def self.update_job_details(job, data)
        p "Updating job details - #{job.job_title}"

        job.update(
          job_title: data['position_name'],
          job_description: data['description'],
          department: data['departmentLabel'],
          employment_type: data['contract_details'],
          country: data['country'],
          location: data['location_display'],
          ats_job_id: data['id']
        )
      end
    end
  end
end
