module Updater
  class ExistingCompanyJobs < ApplicationJob
    include CompanyCsv
    sidekiq_options retry: false

    def perform
      Updater::ExistingCompanyJobs.new.perform
    end
  end
end
