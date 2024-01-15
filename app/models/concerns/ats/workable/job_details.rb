module Ats::Workable::JobDetails
  extend ActiveSupport::Concern

  # TODO: Check if job already exists in database
  # TODO: Change office status to accept booleans
  # TODO: Update job to be able to handle departments and offices
  # TODO: Update job to handle workplace (hybrid)
  # TODO: Update description to handle html and non-html

  def self.get_job_details(job)
    ats = job.company.applicant_tracking_system
    data = fetch_job_data(job, ats)
    update_job_details(job, data)
    p "Updated job details - #{job.job_title}"
    job
  end

  def self.fetch_job_data(job, ats)
    job_url_api = "#{ats.base_url_api}#{job.company.ats_identifier}/jobs/#{job.ats_job_id}"
    uri = URI(job_url_api)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
  end

  def self.update_job_details(job, data)
    job.update(
      job_title: data['title'],
      job_description: data['description'],
      office_status: data['remote'],
      location: data['location']['city'] + ', ' + data['location']['country'],
      country: data['location']['country'],
      # department: data['department'],
      requirements: data['requirements'],
      benefits: data['benefits'],
    )
  end
end
