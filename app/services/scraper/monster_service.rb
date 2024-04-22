require 'open-uri'

module Scraper
  class MonsterService < ApplicationService
    def scrape_page
      url = 'https://www.monster.com/jobs/q-it-jobs'
      page_doc(url).css(".sc-dUWDJJ").css('.job-search-resultsstyle__CardGrid-sc-1wpt60k-3')
                   .css('ul')
                   .css('.job-cardstyle__JobCardComponent-sc-1mbmxes-0').each do |job|
        name = job.css('.sc-gwZKzw').css('h3').css('span').text
        company = Company.find_or_create_by(name:)

        job_attributes = {
          title: job.css('.sc-gwZKzw').css('h3').css('a').text,
          company_id: company.id,
          job_description: job.css('.sc-eiQriw').css('p').text,
          job_posting_url: job.css('.sc-gwZKzw').css('h3').css('a.sc-gAjuZT')[0]['href'],
          location: job.css('.sc-gwZKzw').css('.sc-dABzDS').css('.sc-fICZUB').text,
          date_created: job.css('.sc-gwZKzw').css('.sc-keuYuY').text
        }
        Job.create job_attributes
      end
    end
  end
end
