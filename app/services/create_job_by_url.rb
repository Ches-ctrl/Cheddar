class CreateJobByUrl
  include AtsDetector

  def initialize(url)
    @url = url
  end

  def call
    ats, ats_identifier, job_id = ParseJobUrlByAts.new(@url).parse

    if SUPPORTED_ATS_SYSTEMS.include?(ats.name)
      company = ats.find_or_create_company(ats_identifier)

      puts "Created company - #{company.company_name}" if company.persisted?

      # TODO: To be updated
      # 1. If company is new record, needs to get the company details from the API
      # 2. If company is not a new record, no need to do anything
      # 3. This is CompanyCreator functionality from before

      job = ats.find_or_create_job_by_id(company, job_id) if job_id

      puts "Created job - #{job.job_title}" if job.persisted?

      [ats, company, job]
    else
      ats
    end
  end
end
