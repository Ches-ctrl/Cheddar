module Ats
  module Ashbyhq
    module JobDetails
      def fetch_title_and_location(job_data)
        title = job_data['title']
        job_location = job_data['location']
        [title, job_location]
      end

      def fetch_id(job_data)
        p "Fetching ID: #{job_data['id']}"
        job_data['id']
      end

      private

      def fetch_job_data(job)
        job_id = job.ats_job_id
        all_jobs_data = get_json_data(job.api_url)
        data = all_jobs_data["jobs"]&.find { |job| job["id"] == job_id }

        return data if data

        p "Job with ID #{job_id} is expired."
        job.live = false
        return nil
      end

      def job_details(job, data)
        job.assign_attributes(
          title: data['title'],
          description: data['descriptionHtml'],
          non_geocoded_location_string: build_location_string(data),
          department: data['department'],
          posting_url: data['jobUrl']
        )
      end

      def build_location_string(data)
        locality = data.dig('address', 'postalAddress', 'addressLocality')
        country = data.dig('address', 'postalAddress', 'addressCountry')
        [locality, country].reject(&:blank?).join(', ')
      end

      def job_url_api(url_api, ats_identifier, _job_id)
        "#{url_api}#{ats_identifier}?includeCompensation=true"
      end
    end
  end
end
