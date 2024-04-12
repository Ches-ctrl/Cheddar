module Scraper
  class DevitJobsService < ApplicationService
    include Capybara::DSL
    include ValidUrl

    def scrape_page
      return p "Unable to scrape DevIT: first create ATS" unless (@ats = ApplicantTrackingSystem.find_by(name: 'DevITJobs'))

      @redirect_urls = []

      fetch_json_data.each do |job_data|
        next if redirect?(job_data)

        company = @ats.find_or_create_company_by_data(job_data)
        job = @ats.find_or_create_job_by_data(company, job_data)
        p "Created DevIT job: #{job.job_title}"
      end

      p "grabbing jobs with DevIT redirects..."
      ImportCompaniesFromList.new(@redirect_urls).call unless @redirect_urls.empty?
    end

    private

    def fetch_json_data
      url = @ats.url_all_jobs
      response = get(url)
      JSON.parse(response)
    end

    def redirect?(json_data)
      return false unless json_data['redirectJobUrl']

      @redirect_urls << json_data['redirectJobUrl']
    end
  end
end
