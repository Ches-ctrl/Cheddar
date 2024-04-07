module Scraper
  class DevitJob < ApplicationJob
    queue_as :default

    def perform
      Scraper::DevitJobsService.new.scrape_page
    end
  end
end
