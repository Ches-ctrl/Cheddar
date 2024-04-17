module Ats
  module Greenhouse
    module JobDetails
      def fetch_title_and_location(job_data)
        job_title = job_data['title']
        job_location = job_data.dig('location', 'name')
        [job_title, job_location]
      end

      def fetch_url(job_data)
        job_data['absolute_url']
      end

      private

      def fetch_id(job_data)
        p "Fetching ID: #{job_data['id']}"
        job_data['id']
      end

      def job_url_api(base_url, company_id, job_id)
        "#{base_url}#{company_id}/jobs/#{job_id}?questions=true&pay_transparency=true"
      end

      def update_job_details(job, detailed_data)

        job.job_posting_url = detailed_data['absolute_url']
        job.job_title = detailed_data['title']
        job.job_description = CGI.unescapeHTML(detailed_data['content'])
        job.non_geocoded_location_string = detailed_data.dig('location', 'name')
        job.department = detailed_data.dig('departments', 0, 'name')
        job.office = detailed_data.dig('offices', 0, 'name')
        job.date_created = convert_from_iso8601(detailed_data['updated_at'])

        puts "Created new job - #{job.job_title} with #{job.company.company_name}"
      end
    end
  end
end
