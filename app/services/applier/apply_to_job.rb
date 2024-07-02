module Applier
  # Core class for applying to jobs
  class ApplyToJob
    attr_accessor :job_application_id, :user_id

    def initialize(job_application_id, user_id)
      @job_application_id = job_application_id
      @user_id = user_id
    end

    def apply
      p "Hello from the job application job!"
      application = JobApplication.find(@job_application_id)
      job = application.job
      user = User.find(@user_id)

      application_criteria = assign_values_to_form(application, user)
      fields_to_fill = application_criteria

      ## Already done by Payload up to here

      form_filler = Applier::FormFiller.new(job.posting_url, fields_to_fill, @job_application_id)
      result = form_filler.fill_out_form

      user_channel_name = "job_applications_#{user.id}"

      p "result: #{result}"
      status = result ? "Applied" : "Submission failed"
      p "status: #{status}"

      # TODO: Replace this with sidekiq-status gem capabilities
      ActionCable.server.broadcast(
        user_channel_name,
        {
          event: "job_application_submitted",
          job_application_id: application.id,
          user_id: application.user.id,
          job_id: job.id,
          status:
        }
      )
    end
  end
end
