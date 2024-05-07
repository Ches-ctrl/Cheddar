module Ats
  module Manatal
    module JobDetails
      def fetch_title_and_location(job_data)
        title = job_data['position_name']
        job_location = job_data['location_display']
        [title, job_location]
      end

      def fetch_id(job_data)
        job_data['hash']
      end

      private

      def fetch_job_data(job)
        jobs = fetch_company_jobs(job.company.ats_identifier)
        job_data = jobs.find { |data| data["hash"] == job.ats_job_id }
        return mark_job_expired(job) unless job_data

        job.api_url = "#{job.api_url}#{job_data['id']}"
        return job_data
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
        title, location = fetch_title_and_location(data)
        job.assign_attributes(
          title:,
          description: data['description'],
          department: data['departmentLabel'],
          employment_type: data['contract_details'],
          non_geocoded_location_string: location,
          posting_url: "#{url_base}#{job.company.ats_identifier}/job/#{job.ats_job_id}/apply"
        )
      end

      # def build_location_string(data)
      #   locality = data['location_display']
      #   country = data['country']
      #   [locality, country].reject(&:blank?).join(', ')
      # end
    end
  end
end
