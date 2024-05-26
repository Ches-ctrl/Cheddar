module Api
  class DevitJobsJob < ApplicationJob
    queue_as :updates
    sidekiq_options retry: false

    def perform
      Api::DevitJobs.new.import_jobs
    end
  end
end
