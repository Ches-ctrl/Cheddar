module Url
  class CreateJobFromUrlJob < ApplicationJob
    queue_as :default
    retry_on StandardError, attempts: 0

    def self.perform(url)
      Url::CreateJobFromUrl.new(url).create_company_then_job
    end
  end
end
