module Scraper
  class DevitJob < ApplicationJob
    queue_as :updates
    sidekiq_options retry: false

    def perform
      Scraper::DevitJobsService.new.scrape_page
    end
  end
end
