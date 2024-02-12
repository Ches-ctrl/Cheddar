module Ats::Ashbyhq::JobDetails
  extend ActiveSupport::Concern

  # TODO: Check if job already exists in database
  # TODO: Update job to handle workplace (hybrid)
  # TODO: Update description to handle html and non-html, add labelling for this characteristic

  def self.get_job_details(job)
    ats = job.company.applicant_tracking_system
    data = fetch_job_data(job, ats)
    update_job_details(job, data) if job.live
    p "Updated job details - #{job.job_title}"
    job
  end

  def self.fetch_job_data(job, ats)
    job_url_api = "#{job.company.url_ats_api}"
    job.api_url = job_url_api
    job_id = job.ats_job_id
    uri = URI(job_url_api)
    response = Net::HTTP.get(uri)
    all_jobs_data = JSON.parse(response)
    data = all_jobs_data["jobs"].find { |job| job["id"] == job_id }

    if data
      return data
    else
      p "Job with ID #{job.ats_job_id} is expired."
      job.live = false
      return nil
    end
  end

  def self.update_job_details(job, data)
    job.update(
      job_title: data['title'],
      job_description: data['description'],
      office_status: data['remote'] ? 'Remote' : 'On-site',
      location: data['location']['city'] + ', ' + data['location']['country'],
      country: data['location']['country'],
      department: data['department'],
      requirements: data['requirements'],
      benefits: data['benefits'],
    )
  end
end
