module Build
  class AllJobsJob < ApplicationJob
    queue_as :updates
    retry_on StandardError, attempts: 0

    def perform
      Builders::JobBuilder.new.build
    end
  end
end
