module Ats
  module Greenhouse
    module JobDetails
      private

      def fetch_title_and_location(job_data)
        title = job_data['title']
        job_location = job_data.dig('location', 'name')
        [title, job_location]
      end

      def fetch_url(job_data)
        job_data['absolute_url']
      end

      def fetch_id(job_data)
        p "Fetching ID: #{job_data['id']}"
        job_data['id']
      end

      def job_url_api(base_url, company_id, job_id)
        "#{base_url}#{company_id}/jobs/#{job_id}?questions=true&pay_transparency=true"
      end

      def job_details(job, detailed_data)
        job.assign_attributes(
          job_posting_url: detailed_data['absolute_url'],
          title: detailed_data['title'],
          job_description: detailed_data['content'],
          non_geocoded_location_string: detailed_data.dig('location', 'name'),
          department: detailed_data.dig('departments', 0, 'name'),
          office: detailed_data.dig('offices', 0, 'name'),
          date_created: convert_from_iso8601(detailed_data['updated_at'])
        )
      end
    end
  end
end
