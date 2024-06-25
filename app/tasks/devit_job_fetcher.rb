class DevitJobFetcher
  def initialize(job_data)
    @job_data = job_data
  end

  def call
    return process_as_devit_job unless processable

    process
  end

  def processable
    @job_data['redirectJobUrl'].present?
  end

  def process
    url = @job_data['redirectJobUrl']
    _ats, _company, job = Url::CreateJobFromUrl.new(url).create_company_then_job
    process_as_devit_job unless job
  end

  def process_as_devit_job
    ats = ApplicantTrackingSystem.find_by(name: 'DevITJobs')
    company = ats.find_or_create_company_by_data(@job_data)
    p "Company: #{company&.name}"
    job = ats.find_or_create_job_by_data(company, @job_data)
    p "Job: #{job&.title}"
  rescue StandardError => e
    Rails.logger.error "Error creating company and job: #{e.message}"
  end
end
