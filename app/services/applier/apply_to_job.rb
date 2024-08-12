# frozen_string_literal: true

module Applier
  # Core class for applying to jobs using either ApiApply or FormFiller depending on the ATS
  # TODO: Add routing logic - in future will route to either FormFiller or ApiApply depending on the ATS
  class ApplyToJob < ApplicationTask
    def initialize(job_application)
      p "Initializing job_application: #{job_application}" # for testing
      @job_application = job_application
      @payload = @job_application.payload
    end

    def call
      return unless processable

      process
      # rescue StandardError => e
      #   Rails.logger.error "Error submitting job application: #{e.message}"
      #   nil
    end

    private

    def processable
      @payload && @payload[:apply_url]
    end

    def process
      select_form_filler
      apply_with_form_filler
    end

    def apply_with_form_filler
      @form_filler.call(@payload)
    end

    def check_which_greenhouse
      @payload[:apply_url].include?('job-boards') ? GreenhouseFormFiller : GhFormFiller
    end

    def form_filler
      {
        'Greenhouse' => check_which_greenhouse,
        'AshbyHQ' => AshbyFormFiller,
        'BambooHR' => BambooFormFiller,
        'DevITJobs' => DevitFormFiller,
        'Workable' => WorkableFormFiller
      }
    end

    def select_form_filler
      ats = @job_application&.applicant_tracking_system&.name
      @form_filler = form_filler[ats]
    end
  end
end
