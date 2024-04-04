module Xml
  class WorkableService < ApplicationService
    def scrape_page
      return "Unable to scrape Workable: first create ATS" unless (ats = ApplicantTrackingSystem.find_by(name: 'Workable'))

      url = ats.url_xml
      jobs = page_doc(url).xpath('//source/job')

      # NB. Doesn't work yet

      jobs.each do |job_data|
        ats_identifier = job_data.css('company').text.gsub(' ', '-').gsub(/[^A-Za-z\-]/, '')
        company = Company.find_or_create_by(ats_identifier:) do |new_company|
          new_company.company_name = job_data.css('company').text
          new_company.website_url = job_data.css('website').text
          new_company.applicant_tracking_system = ats
        end
        ats.find_or_create_job_by_data(company, job_data)
      end
    end
  end
end
