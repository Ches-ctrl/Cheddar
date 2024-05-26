module Scraper
  class DevitJobsJob < ApplicationJob
    queue_as :updates
    sidekiq_options retry: false

    def perform
      Api::DevitJobs.new.scrape_page
    end
  end
end
