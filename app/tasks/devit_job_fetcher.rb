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
    _ats, _company, job = Url::CreateJobFromUrl.new(url).create_company_then_job
    process_as_devit_job unless job
  end

  def process_as_devit_job

  end
end
