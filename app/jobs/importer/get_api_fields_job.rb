module Importer
  class GetApiFieldsJob < ApplicationJob
    include Sidekiq::Status::Worker

    queue_as :importers
    sidekiq_options retry: false

    def perform(job)
      Importer::GetApiFields.call(job)
    end
  end
end
