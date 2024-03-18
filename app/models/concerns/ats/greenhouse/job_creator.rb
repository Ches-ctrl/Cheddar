module Ats::Greenhouse::JobCreator
  extend ActiveSupport::Concern

  def self.new_job(company, job_data)
    job_posting_url = job_data['absolute_url']
    job = Job.find_or_create_by(job_posting_url:) do |new_job|
      detailed_data = get_job_data(new_job, job_data['id'], company.ats_identifier)
      puts "Created new job - #{new_job.job_title} with #{company.company_name}"
      new_job.job_title = job_data['title']
      new_job.company = company
      new_job.job_description = CGI.unescapeHTML(detailed_data['content'])
      new_job.non_geocoded_location_string = job_data['location']['name']
      new_job.department = detailed_data['departments'][0]['name'] unless detailed_data['departments'].empty?
      new_job.office = detailed_data['offices'][0]['name'] unless detailed_data['offices'].empty?
      new_job.date_created = convert_from_iso8601(job_data['updated_at'])
    end
    return job
  end

  private

  private_class_method def self.get_job_data(job, job_id, company_ats_identifier)
    job_url_api = "https://boards-api.greenhouse.io/v1/boards/#{company_ats_identifier}/jobs/#{job_id}"
    job.api_url = job_url_api
    uri = URI(job_url_api)
    response = Net::HTTP.get(uri)
    return JSON.parse(response)
  end

  private_class_method def self.convert_from_iso8601(iso8601_string)
    return Time.iso8601(iso8601_string)
  end
end
