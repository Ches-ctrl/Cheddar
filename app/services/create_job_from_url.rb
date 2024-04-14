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

    p company

    # At this point, we have the ATS, company and job_id
    # If we're calling job_creator directly, we'll have the ATS, company and url
    # The url will always contain the job id, so we can use that to get the job details
    # There are a couple of ways we could pass this to the job_creator method
    # We also need to be conscious of what order we query the API in depending on the API's structure

    # ---------------
    # JobCreator
    # ---------------

    # TODO: Fix this method, all ATS API integrations have get_job_details but it's not yet passing the correct variables back and forth
    # TODO: Greenhouse, lever and Devit will then need updating separately given Dan changes
    # TODO: Fix this as at the moment it breaks whenever the job_posting_url is no longer valid
    # TODO: We also need a way of managing what happens when companies switch ATS systems - this is probably just a flag in the first instance
    # TODO: Find a recruitee job_posting_url as currently don't have one to test

    job = ApplicantTrackingSystem.create_job(@url, ats, company, job_id)
    puts "Created job - #{job.job_title}"

    # ---------------
    # GetAllJobUrls
    # ---------------

    # TODO: Create background job to get all job urls later (template but not fully setup yet)

    # urls = ats.get_company_jobs(@url)
    # AddRemainingJobsToSite.new(urls, ats, company).add_jobs

    [ats, company, job]
  end
end
