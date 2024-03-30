module Ats
  module Devit
    module JobDetails
      # TODO: Check if job already exists in database
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
        job_data.css('link').text.match(%r{https://devitjobs.uk/jobs/(.+)})[1]
      end

      def job_url_api(base_url, _company_id, _job_id)
        return base_url
      end

      def update_job_details(job, data)
        job.job_posting_url = data.css('apply_url').text
        job.job_title = data.css('title').text
        job.job_description = data.css('description').text
        job.salary = data.css('salary').text
        job.remote_only = data.css('location').text == 'Full Remote'
        job.non_geocoded_location_string = job.remote_only ? data.css('country').text : "#{data.css('location').text} #{data.css('postal_code').text}"
        job.employment_type = data.css('jobtype').text
        job.date_created = Date.strptime(data.css('pubdate').text, "%d.%m.%Y")
        fetch_additional_fields(job)
        puts "Created new job - #{job.job_title} with #{job.company.company_name}"
      end
    end
  end
end
