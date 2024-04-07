class CreateJobFromUrl
  include AtsSystemParser

  def initialize(url)
    @url = url
  end

  def create_company_then_job
    # ---------------
    # ATS Router
    # ---------------

    # TODO: determine_ats needs to handle job boards, company sites and other companies not in the DB, as well as non-valid URLs

    ats = ApplicantTrackingSystem.determine_ats(@url)
    p "ATS - #{ats.name}"

    # ---------------
    # Parse URL
    # ---------------

    ats_identifier, job_id = ApplicantTrackingSystem.parse_url(ats, @url)
    p "ATS Identifier - #{ats_identifier}"
    p "Job ID - #{job_id}"

    # ---------------
    # CompanyCreator
    # ---------------

    company = ApplicantTrackingSystem.get_company_details(@url, ats, ats_identifier)
    puts "Created company - #{company.company_name}"

    # ---------------
    # JobCreator
    # ---------------

    job = ApplicantTrackingSystem.get_job_details(ats, company, url, ats_job_id)
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
