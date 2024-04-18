module Ats
  module Manatal
    module JobDetails
      private

      def fetch_job_data(job)
        page = 1
        url = "#{job_url_api}?page=#{page}"
        p "Fetching job data - #{url}"

        loop do
          response = get(url)
          all_jobs_data = JSON.parse(response)
          jobs = all_jobs_data["results"]

          data = jobs.find { |job_data| job_data["hash"] == job.ats_job_id }

          if data
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

      def job_url_api(base_url, company_id, _job_id)
        "#{base_url}#{company_id}/jobs/"
      end

      def job_details(job, data)
        job.assign_attributes(
          job_title: data['position_name'],
          job_description: data['description'],
          department: data['departmentLabel'],
          employment_type: data['contract_details'],
          non_geocoded_location_string: build_location_string(data)
        )
      end

      def build_location_string(data)
        locality = data['location_display']
        country = data['country']
        [locality, country].compact.join(', ')
      end
    end
  end
end
