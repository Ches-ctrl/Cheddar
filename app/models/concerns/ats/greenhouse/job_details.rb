module Ats
  module Greenhouse
    module JobDetails
      extend ActiveSupport::Concern
      extend AtsMethods

      # TODO: Check if job already exists in database
      def self.find_or_create_by_id(company, ats_job_id)
        job = Job.find_or_create_by(ats_job_id:) do |new_job|
          new_job.company = company
          data = fetch_job_data(new_job)
          return unless (new_job.job_posting_url = data['absolute_url'])

          new_job.job_title = data['title']
          new_job.job_description = CGI.unescapeHTML(data['content'])
          new_job.non_geocoded_location_string = data['location']['name']
          new_job.department = data['departments'][0]['name'] unless data['departments'].blank?
          new_job.office = data['offices'][0]['name'] unless data['offices'].blank?
          new_job.date_created = convert_from_iso8601(data['updated_at'])
          fetch_additional_fields(new_job)
          puts "Created new job - #{new_job.job_title} with #{company.company_name}"
        end

        return job
      end

      def self.fetch_job_data(job)
        ats = this_ats
        job_url_api = "#{ats.base_url_api}#{job.company.ats_identifier}/jobs/#{job.ats_job_id}"
        job.api_url = job_url_api
        uri = URI(job_url_api)
        response = Net::HTTP.get(uri)
        return JSON.parse(response)
      end

      def self.fetch_title_and_location(job_data)
        job_title = job_data['title']
        job_location = job_data['location']['name']
        [job_title, job_location]
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
