module Scraper
  class DevitJobsService < ApplicationService
    include Capybara::DSL
    include ValidUrl

    def scrape_page
      return p "Unable to scrape DevIT: first create ATS" unless (@ats = ApplicantTrackingSystem.find_by(name: 'DevITJobs'))

      url = @ats.url_xml
      jobs = page_doc(url).xpath('//jobs/job')
      @redirect_urls = []

      jobs.each do |job_data|
        @job_url = job_data.css('apply_url').text
        next if redirect?

        ats_identifier = job_data.css('company').text.gsub(' ', '-').gsub(/[^A-Za-z\-]/, '')

        company = Company.find_or_create_by(ats_identifier:) do |new_company|
          new_company.company_name = job_data.css('company').text
          new_company.applicant_tracking_system = @ats
        end

        date_posted = Date.strptime(job_data.css('pubdate').text, "%d.%m.%Y")
        @ats.find_or_create_job_by_data(company, job_data) if (Date.today - date_posted) < 60
      end

      ImportCompaniesFromList.new(@redirect_urls).call unless @redirect_urls.empty?
      # NOTE: original implementation for technologies and locations were changed,
      # I am not sure how locations and technologies works now, will leave for Dan to fix.
      # technologies is currently part of the string in the description, some string manipulation is needed to get it.
    end

    private

    def redirect?
      Capybara.current_driver = :selenium_chrome_headless
      visit @job_url
      wait_for_javascript

      return false unless (redirect_job_url = evaluate_script('window.__detailedJob.redirectJobUrl'))

      @redirect_urls << redirect_job_url
    end

    def wait_for_javascript
      Timeout.timeout(10) do
        loop until evaluate_script('typeof window.__detailedJob !== "undefined"')
      end
    rescue Timeout::Error
      raise "Timed out waiting for JavaScript to execute"
    end
  end
end
