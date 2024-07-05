module Url
  class CreateTrueupJobFromUrlJob < ApplicationJob
    queue_as :default
    retry_on StandardError, attempts: 0

    def perform(job_data)
      jobs = job_data.dig('results', 0, 'hits')
      return unless jobs

      jobs.each { |job| TrueupJobFetcher.call(job) }
    end
  end
end
