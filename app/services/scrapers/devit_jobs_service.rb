module Scrapers
  class DevitJobsService < ApplicationService
    def scrape_page
      url = 'https://devitjobs.uk/job_feed.xml'
      jobs = page_doc(url).xpath('//jobs/job')
      jobs.each do |job|
        company = Company.find_or_create_by(company_name: job.css('company-name').text)

        job_attributes = {
          job_title: job.css('title').text,
          company_id: company.id,
          job_description: job.css('description').text,
          job_posting_url: job.css('apply_url').text,
          salary: job.css('salary').text,
          date_created: job.css('pubdate').text
          # more attributes can be added once confirmed
        }

        Job.create! job_attributes
      end

      # NOTE: original implementation for technologies and locations were changed,
      # I am not sure how locations and technologies works now, will leave for Dan to fix.
      # technologies is currently part of the string in the description, some string manipulation is needed to get it.
    end

    def location(name)
      city = name.split(',').last
      geo = Geocoder.search(city)
      country = Country.find_or_create_by(name: geo.first.country)
      Location.find_or_create_by(city:, country_id: country.id)
    end
  end
end
