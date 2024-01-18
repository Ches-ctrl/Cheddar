module Ats::Lever::JobDetails
  extend ActiveSupport::Concern

  # TODO: Check if job already exists in database
  # TODO: Update job to handle workplace (hybrid)
  # TODO: Update description to handle html and non-html, add labelling for this characteristic

  def self.get_job_details(job)
    ats = job.company.applicant_tracking_system
    data = fetch_job_data(job, ats)
    update_job_details(job, data)
    p "Updated job details - #{job.job_title}"
    job
  end

  def self.fetch_job_data(job, ats)
    job_url_api = "#{ats.base_url_api}#{job.company.ats_identifier}/#{job.ats_job_id}"
    job.api_url = job_url_api
    uri = URI(job_url_api)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
  end

  def self.update_job_details(job, data)
    # TODO: add logic for office

    timestamp = data['createdAt'] / 1000
    created_at_time = Time.at(timestamp)
    p "Job created at: #{created_at_time}"

    lines = data['descriptionPlain'].split("\n")

    lines.each do |line|
      line.strip!
      if line =~ /^Salary: (.+)/i
        salary = $1
      elsif line =~ /^Type: (.+)/i
        full_time = $1
      end
      # Will search the remainder of the description needlessly at the moment
    end

    job.update(
      job_title: data['text'],
      job_description: data['descriptionPlain'],
      office_status: data['workplaceType'],
      location: data['categories']['location'] + ', ' + data['country'],
      country: data['country'],
      department: data['categories']['team'],
      requirements: data['requirements'],
      benefits: data['benefits'],
      date_created: created_at_time,
      industry: job.company.industry,
      salary: salary,
      employment_type: full_time,
    )
  end
end
