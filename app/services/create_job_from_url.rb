class CreateJobFromUrl
  include AtsSystemParser

  def initialize(url)
    @url = url
  end

  def create_company_then_job
    # ---------------
    # ATS Router
    # ---------------

    ats = ATS.determine_ats(@url)

    # ---------------
    # Parse URL
    # ---------------

    ats, ats_identifier, job_id = ATS.parse_url(ats, @url)

    # ---------------
    # CompanyCreator
    # ---------------

    company = ATS.find_or_create_company(ats, ats_identifier)
    puts "Created company - #{company.company_name}" if company.persisted?

    # ---------------
    # JobCreator
    # ---------------

    job = ats.find_or_create_job_by_id(company, job_id) if job_id
    puts "Created job - #{job.job_title}" if job.persisted?

    # ---------------
    # GetAllJobUrls
    # ---------------

    # TODO: Create background job to get all job urls later (template but not fully setup yet)

    # urls = ats.get_company_jobs(@url)
    # AddRemainingJobsToSite.new(urls, ats, company).add_jobs

    [ats, company, job]
  end
end
