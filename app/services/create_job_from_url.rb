class CreateJobFromUrl
  include AtsSystemParser

  def initialize(url)
    @url = url
  end

  def create_company_then_job
    # ---------------
    # ATS Router
    # ---------------

    ats = ApplicantTrackingSystem.determine_ats(@url)
    p ats

    # ---------------
    # Parse URL
    # ---------------

    ats_identifier, job_id = ApplicantTrackingSystem.parse_url(ats, @url)
    p ats
    p ats_identifier
    p job_id

    # ---------------
    # CompanyCreator
    # ---------------

    company = ApplicantTrackingSystem.find_or_create_company(ats, ats_identifier)
    puts "Created company - #{company.company_name}" if company.persisted?

    # ---------------
    # JobCreator
    # ---------------

    job = ApplicantTrackingSystem.get_job_details(ats, job_id)
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
