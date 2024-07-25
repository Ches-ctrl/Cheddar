# frozen_string_literal: true

module Applier
  class ApplyJob < ApplicationJob
    include Sidekiq::Status::Worker

    queue_as :default
    sidekiq_options retry: false

    def perform(job_application)
      # check that job_application.status == 'Completed'
      # extract payload with job_application.payload

      Applier::ApplyToJob.call(job_application)
    end
  end
end
