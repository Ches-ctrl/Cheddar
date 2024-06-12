module Applier
  class ApplyToJob
    # TODO: Tidy up (1) ApplyJob (2) FormFiller and (3) SubmitApplication so that the correct functionality sits in each class/module
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

      form_filler = Applier::FormFiller.new(job.posting_url, fields_to_fill, @job_application_id)
      result = form_filler.fill_out_form

      user_channel_name = "job_applications_#{user.id}"

      p "result: #{result}"
      status = result ? "Applied" : "Submission failed"
      p "status: #{status}"

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

    private

    def assign_values_to_form(application, user)
      application_criteria = application.job.application_criteria
      custom_fields = {}
      ApplicationResponse.where(job_application_id: application.id).each do |response|
        custom_fields[response.field_name] = response.field_value
      end

      application_criteria.each_key do |key|
        if custom_fields[key].nil? && user.respond_to?(key) && user.send(key).present?
          application_criteria[key]['value'] = user.send(key)
        else
          application_criteria[key]['value'] = custom_fields[key]
        end
      end
      return application_criteria
    end
  end
end
