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

      def self.create_job(job_data, company)
        job_posting_url = job_data['absolute_url']
        job = Job.find_or_create_by!(job_posting_url:) do |new_job|
          detailed_data = get_job_data(new_job, job_data['id'], company.ats_identifier)
          puts "Created new job - #{new_job.job_title} with #{company.company_name}"
          new_job.job_title = job_data['title']
          new_job.company = company
          new_job.job_description = CGI.unescapeHTML(detailed_data['content'])
          new_job.non_geocoded_location_string = job_data['location']['name']
          new_job.department = detailed_data['departments'][0]['name']
          new_job.office = detailed_data['offices'][0]['name'] unless detailed_data['offices'].empty?
          new_job.date_created = convert_from_iso8601(job_data['updated_at'])
        end
        return job
      end

      def self.get_job_data(job, job_id, company_ats_identifier)
        job_url_api = "https://boards-api.greenhouse.io/v1/boards/#{company_ats_identifier}/jobs/#{job_id}"
        job.api_url = job_url_api
        uri = URI(job_url_api)
        response = Net::HTTP.get(uri)
        return JSON.parse(response)
      end

      def self.fetch_job_data(job, ats)
        job_url_api = "#{ats.base_url_api}#{job.company.ats_identifier}/jobs/#{job.ats_job_id}"
        job.api_url = job_url_api
        uri = URI(job_url_api)
        response = Net::HTTP.get(uri)
        return JSON.parse(response)
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
