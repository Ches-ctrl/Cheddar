module Url
  class CreateTrueupJobFromUrlJob < ApplicationJob
    queue_as :default
    retry_on StandardError, attempts: 0

    def perform(job_data)
      TrueupJobFetcher.call(job_data)
    end
  end
end
