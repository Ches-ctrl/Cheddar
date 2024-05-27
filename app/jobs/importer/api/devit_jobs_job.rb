module Importer
  module Api
    class DevitJobsJob < ApplicationJob
      queue_as :updates
      sidekiq_options retry: false

      def perform
        Importer::Api::DevitJobs.new.import
      end
    end
  end
end
