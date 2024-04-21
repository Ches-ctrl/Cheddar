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
      return handle_unparseable unless ats
      return nil unless job_id

      if job_is_live?(@url, ats)
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

    def handle_unparseable
      puts "Scraping meta tags for ATS information on #{@url}..."
      ats, company = ScrapeMetaTags.new(@url).call
      return [ats, company] if company&.persisted?

      add_url_to_unparseable_list(ats&.name)
    end

    def add_url_to_unparseable_list(ats_name = 'Unknown')
      # NB: This currently creates duplicate listings, which is annoying, but can't be fixed without
      # reading the whole csv file when adding a single line. This issue will become moot once the csv
      # file is replaced by a Url model with uniqueness validation
      db_filepath = Rails.root.join('storage', 'csv', 'unparseable_urls.csv')
      CSV.open(db_filepath, 'a') do |csv|
        csv << [@url, ats_name]
      end
    end
  end
end
