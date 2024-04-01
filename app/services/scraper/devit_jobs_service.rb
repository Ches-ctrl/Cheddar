module Scraper
  class DevitJobsService < ApplicationService
    def scrape_page
      return "Unable to scrape DevIT: first create ATS" unless (ats = ApplicantTrackingSystem.find_by(name: 'Devit'))

      url = ats.url_xml
      jobs = page_doc(url).xpath('//jobs/job')

      jobs.each do |job_data|
        # TODO: check for apply redirect to different ATS
        ats_identifier = job_data.css('company').text.gsub(' ', '-').gsub(/[^A-Za-z\-]/, '')
        
        company = Company.find_or_create_by(ats_identifier:) do |new_company|
          new_company.company_name = job_data.css('company').text
          new_company.applicant_tracking_system = ats
        end
        ats.find_or_create_job_by_data(company, job_data)
      end

      # NOTE: original implementation for technologies and locations were changed,
      # I am not sure how locations and technologies works now, will leave for Dan to fix.
      # technologies is currently part of the string in the description, some string manipulation is needed to get it.
    end
  end
end
