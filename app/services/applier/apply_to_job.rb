# frozen_string_literal: true

module Applier
  # Core class for applying to jobs using either ApiApply or FormFiller depending on the ATS
  # TODO: Add routing logic - in future will route to either FormFiller or ApiApply depending on the ATS
  class ApplyToJob < ApplicationTask
    def initialize(job_application, payload)
      @job_application = job_application
      @payload = payload
    end

    def call
      return unless processable

      process
    rescue StandardError => e
      Rails.logger.error "Error submitting job application: #{e.message}"
      nil
    end

    private

    def processable
      @job_application && @payload
    end

    def process
      apply_with_form_filler
    end

    def apply_with_form_filler
      Applier::FormFiller.call(@job_application, @payload)
    end
  end
end
