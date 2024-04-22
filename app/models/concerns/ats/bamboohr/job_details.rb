module Ats
  module Bamboohr
    module JobDetails
      private

      def fetch_job_data(job)
        job_id = job.ats_job_id

        all_jobs_data = get_json_data(job.api_url)
        data = all_jobs_data["result"]&.find { |job| job["id"] == job_id }

        return data if data

        p "Job with ID #{job_id} is expired."
        job.live = false
        return nil
      end

      def job_details(job, data)
        job.assign_attributes(
          job_title: data['jobOpeningName'],
          department: data['departmentLabel'],
          employment_type: data['employmentStatusLabel'],
          non_geocoded_location_string: build_location_string(data),
          job_posting_url: "#{url_base.sub('XXX', job.company.ats_identifier)}#{data['id']}"
        )
      end

      def job_url_api(_base_url, ats_identifier, _job_id)
        company = Company.find_by(ats_identifier:)
        company.url_ats_api
      end

      def build_location_string(data)
        locality = data.dig('location', 'city')
        country = data.dig('location', 'state')
        [locality, country].reject(&:blank?).join(', ')
      end
    end
  end
end
