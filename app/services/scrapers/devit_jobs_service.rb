module Scrapers
  class DevitJobsService < ApplicationService
    include Capybara::DSL

    def scrape_page
      job_urls = []
      url = 'https://devitjobs.uk'
      jobs_list = page_doc(url).css('.joblist-container').css('ul').css('li')
      jobs_list.each do |job|
        job_urls << job.css('.swissdev-grey-background').css('.card').at('a')['href']
        puts job.css('.swissdev-grey-background').css('.card').css('.col-9').css('.cut-long-name').text
        
        job_url =  "https://devitjobs.uk#{job.css('.swissdev-grey-background').css('.card').at('a')['href']}"
        job_details = page_doc(job_url)

        technologies = []

        # find or create company
        company_name = job_details.css('.swissdev-grey-text').css('span.text-small').text
        company = Company.find_or_create_by(company_name: company_name)

        # find or create technologies
        job_details.css('.job-details-section-box').css('.mr-2').each do |tech|
          technologies << Technology.find_or_create_by(name: tech.css('a').text)
        end

        location_name = job_details.css('.swissdev-grey-text').css('span.text-small').css('div.d-flex').text

        job_attributes = {
          job_title: job_details.css('.only-mobile').css('h1').text,
          company_id: company.id,
          job_description: job.css('.sc-eiQriw').css('p').text,
          job_posting_url: job_url
        }
        job = Job.create job_attributes

        # job_technologies join 
        job.technologies << technologies

        # job location
        job.locations << location(location_name)
      end
    end

    def location(name)
      city = name.split(',').last
      geo = Geocoder.search(city)
      country = Country.find_or_create_by(name: geo.first.country)
      Location.find_or_create_by(city: city, country_id: country.id)
    end
  end
end
