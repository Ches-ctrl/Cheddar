module Scraper
  class DevitJobsJob < ApplicationJob
    queue_as :updates
    sidekiq_options retry: false

    def perform
      Scraper::DevitJobs.new.scrape_page
    end
  end
end
