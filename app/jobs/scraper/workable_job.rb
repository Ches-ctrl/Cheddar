module Scraper
  class WorkableJob < ApplicationJob
    queue_as :default

    def perform
      Scraper::WorkableJobsService.import_jobs
    end
  end
end
