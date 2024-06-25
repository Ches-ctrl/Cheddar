module Url
  class CreateDevitJobFromUrlJob < ApplicationJob
    queue_as :default
    retry_on StandardError, attempts: 0

    def perform(job_data)
      DevitJobCreator.new(job_data).call
    end
  end
end
