# frozen_string_literal: true

module Applier
  class ApplyJob < ApplicationJob
    include Sidekiq::Status::Worker

    queue_as :default
    sidekiq_options retry: false

    def perform(job_application)
      # NB: There isn't enough time for job_application.status to update from 'completed' to 'submitted' when running the job inline in test environment
      Applier::ApplyToJob.call(job_application)
      # Applier::ApplyToJob.call(job_application) if job_application.status == 'submitted'
    end
  end
end
