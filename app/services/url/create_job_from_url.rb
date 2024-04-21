module Url
  class CreateJobFromUrl
    include CheckUrlIsValid
    include AtsSystemParser

    def initialize(url)
      @url = url
    end

    def create_company_then_job
      # ---------------
      # Create Company From URL
      # ---------------

      ats, company, job_id = Url::CreateCompanyFromUrl.new(@url).create_company
      return nil unless job_id

      if job_is_live?(@url)
        p "Live Job - #{@url}"
        job = ats.find_or_create_job(company, job_id)
        puts "Created job - #{job&.job_title}"
      else
        p "Job has expired - #{@url}"
      end

      # ---------------
      # GetAllJobUrls
      # ---------------

      # TODO: Create background job to get all job urls later (template but not fully setup yet)

      # urls = ats.get_company_jobs(@url)
      # AddRemainingJobsToSite.new(urls, ats, company).add_jobs

      job
    end
  end
end
