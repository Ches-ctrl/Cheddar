module Updater
  class ExistingCompanyJobs < ApplicationJob
    include CompanyCsv
    sidekiq_options retry: false

    def perform
      Updater::ExistingCompanyJobsService.new.call
    end
  end
end
