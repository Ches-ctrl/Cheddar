module Ats
  module Greenhouse
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
        job_data['id']
      end

      private_class_method def self.job_url_api(base_url, company_id, job_id)
        "#{base_url}#{company_id}/jobs/#{job_id}"
      end

      private_class_method def self.update_job_details(job, _data)
        detailed_data = fetch_job_data(job)
        job.job_posting_url = detailed_data['absolute_url']
        job.job_title = detailed_data['title']
        job.job_description = CGI.unescapeHTML(detailed_data['content'])
        job.non_geocoded_location_string = detailed_data.dig('location', 'name')
        job.department = detailed_data.dig('departments', 0, 'name')
        job.office = detailed_data.dig('offices', 0, 'name')
        job.date_created = convert_from_iso8601(detailed_data['updated_at'])
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
