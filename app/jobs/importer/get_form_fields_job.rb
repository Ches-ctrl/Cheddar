module Importer
  class GetFormFieldsJob < ApplicationJob
    queue_as :importers
    sidekiq_options retry: false

    def perform
      Importer::GetFormFields.new.perform
    end
  end
end
