module Applier
  # Core class for applying to jobs using either ApiApply or FormFiller depending on the ATS
  class ApplyToJob < ApplicationTask
    def initialize(job_application, payload)
      @job_application = job_application
      @job = @job_application.job
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
      @job_application && @job && @payload # && @user
    end

    def process
      p "Hello from the job application service class!"
      p @payload
      spin_up_form_filler
    end

    # TODO: In future will route to either FormFiller or ApiApply depending on the ATS - add routing logic
    def spin_up_form_filler
      Applier::FormFiller.call(@job.posting_url, @payload, @job_application)
    end

    # def create_action_cable_broadcast
    #  ActionCable.server.broadcast(
    #    user_channel_name,
    #    {
    #      event: "job_application_submitted",
    #      job_application_id: application.id,
    #      user_id: application.user.id,
    #      job_id: job.id,
    #      status:
    #    }
    #  )
    # end
  end
end
