module Ats::Greenhouse::JobDetails
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
    data = JSON.parse(response)
  end

  def self.update_job_details(job, data)
    decoded_description = CGI.unescapeHTML(data['content'])

    job.update(
      job_title: data['title'],
      job_description: decoded_description,
      location: data['location']['name'],
      department: data['departments'][0]['name'],
      office: data['offices'][0]['name'],
    )
  end
end
