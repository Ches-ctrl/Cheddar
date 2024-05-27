module Importer
  module Url
    class CreateJobFromUrlJob < ApplicationJob
      queue_as :default
      retry_on StandardError, attempts: 0

      def perform(url)
        Importer::URL::CreateJobFromUrl.new(url).create_company_then_job
      end
    end
  end
end
