module Updater
  class ExistingCompanyJobsJob < ApplicationJob
    include Sidekiq::Status::Worker
    include CompanyCsv

    sidekiq_options retry: false

    def perform
      Updater::ExistingCompanyJobsService.new.call
    end
  end
end
