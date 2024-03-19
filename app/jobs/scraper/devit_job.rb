module Scraper
  class DevitJob < ApplicationJob
    queue_as :default

    def perform
      Scrapers::DevitJobsService.new.scrape_page
    end
  end
end
