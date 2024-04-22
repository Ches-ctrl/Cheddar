module Ats
  module Manatal
    module JobDetails
      private

      def fetch_job_data(job)
        page = 1
        loop do
          url = "#{job.api_url}?page=#{page}"
          p "Fetching job data - #{url}"

          all_jobs_data = get_json_data(url)
          return mark_job_expired(job) unless (jobs = all_jobs_data["results"]) && all_jobs_data["next"]

          data = jobs.find { |job_data| job_data["hash"] == job.ats_job_id }

          if data
            job.api_url = "#{job.api_url}#{data['id']}"
            return data
          end

          page += 1
        end
      end

      def mark_job_expired(job)
        p "Job with ID #{job.ats_job_id} is expired."
        job.live = false
        return nil
      end

      def job_url_api(base_url, company_id, _job_id)
        "#{base_url}#{company_id}/jobs/"
      end

      def job_details(job, data)
        job.assign_attributes(
          title: data['position_name'],
          job_description: data['description'],
          department: data['departmentLabel'],
          employment_type: data['contract_details'],
          non_geocoded_location_string: build_location_string(data),
          job_posting_url: "#{url_base}#{job.company.ats_identifier}/job/#{job.ats_job_id}/apply"
        )
      end

      def build_location_string(data)
        locality = data['location_display']
        country = data['country']
        [locality, country].reject(&:blank?).join(', ')
      end
    end
  end
end
