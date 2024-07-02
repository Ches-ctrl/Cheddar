module Importer
  class GetFormFieldsJob < ApplicationJob
    include Sidekiq::Status::Worker

    queue_as :importers
    sidekiq_options retry: false

    def perform(job)
      Importer::GetFormFields.call(job)
    end
  end
end
