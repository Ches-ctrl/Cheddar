module Ats
  module Greenhouse
    module JobDetails
      extend ActiveSupport::Concern

      # TODO: Check if job already exists in database

      def self.get_job_details(job)
        ats = job.company.applicant_tracking_system
        data = fetch_job_data(job, ats)
        update_job_details(job, data)
        p "Updated job details - #{job.job_title}"
        job
      end

      def self.fetch_job_data(job, ats)
        job_url_api = "#{ats.base_url_api}#{job.company.ats_identifier}/jobs/#{job.ats_job_id}"
        job.api_url = job_url_api
        uri = URI(job_url_api)
        response = Net::HTTP.get(uri)
        JSON.parse(response)
      end

      def self.update_job_details(job, data)
        decoded_description = CGI.unescapeHTML(data['content'])

        job.update(
          job_title: data['title'],
          job_description: decoded_description,
          non_geocoded_location_string: data['location']['name'],
          department: data['departments'][0]['name'],
          office: data['offices'][0]['name'],
          date_created: convert_from_iso8601(data['updated_at'])
        )
      end

      def self.convert_from_iso8601(iso8601_string)
        return Time.iso8601(iso8601_string)
      end
    end
  end
end
