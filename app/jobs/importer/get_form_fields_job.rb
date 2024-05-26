module Importer
  class GetFormFieldsJob < ApplicationJob
    queue_as :importers
    sidekiq_options retry: false

    def perform(job)
      Importer::GetFormFields.new(job).perform
    end
  end
end
