module Ats
  module Devit
    module JobDetails
      extend AtsMethods
      extend JobDetailsMethods

      # TODO: Check if job already exists in database

      def self.fetch_title_and_location(job_data)
        job_title = job_data['title']
        job_location = job_data.dig('location', 'name')
        [job_title, job_location]
      end

      def self.fetch_url(job_data)
        job_data['absolute_url']
      end

      private

      private_class_method def self.fetch_id(job_data)
        job_data.css('link').text.match(%r{https://devitjobs.uk/jobs/(.+)})[1]
      end

      private_class_method def self.job_url_api(base_url, _company_id, _job_id)
        return base_url
      end

      private_class_method def self.update_job_details(job, data)
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

      # def self.update_job_details(job, data)
      #   decoded_description = CGI.unescapeHTML(data['content'])

      #   job.update(
      #     job_title: data['title'],
      #     job_description: decoded_description,
      #     non_geocoded_location_string: data['location']['name'],
      #     department: data['departments'][0]['name'],
      #     office: data['offices'][0]['name'],
      #     date_created: convert_from_iso8601(data['updated_at'])
      #   )
      # end
    end
  end
end
