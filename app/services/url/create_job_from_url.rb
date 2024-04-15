module Url
  class CreateJobFromUrl
    include CheckUrlIsValid
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

      # TODO: Update this and Greenhouse, lever and Devit so they are consistent - at the moment they call different methods
      # TODO: Fix this as at the moment it breaks whenever the job_posting_url is no longer valid
      # TODO: Find a recruitee job_posting_url as currently don't have one to test

      if job_is_live?(@url)
        p "Live Job - #{@url}"
        job = ApplicantTrackingSystem.find_or_create_job_by_id(@url, ats, company, job_id)
        puts "Created job - #{job.job_title}"
      else
        p "Job has expired - #{@url}"
      end

      # ---------------
      # GetAllJobUrls
      # ---------------

      # TODO: Create background job to get all job urls later (template but not fully setup yet)

      # urls = ats.get_company_jobs(@url)
      # AddRemainingJobsToSite.new(urls, ats, company).add_jobs

      [ats, company, job]
    end
  end
end
