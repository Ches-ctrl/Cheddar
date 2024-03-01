module JobApplication
  class ApplyJob
    include Defaults::DefaultMale # not really sure if this is needed here, need more clarity before taking it off
    include Defaults::DefaultFemale

    def initialize(user_id, job_application_id)
        @user = User.find(user_id)
        @job_application = JobApplication.find(job_application_id)
    end

    def call
      job = @job_application.job

      fields_to_fill = assign_values_to_form

      form_filler = FormFiller.new
      form_filler.fill_out_form(job.job_posting_url, fields_to_fill, @job_application.id)

      Capybara.send(:session_pool).each { |name, ses| ses.driver.quit }

      user_channel_name = "job_applications_#{@user.id}"

      ActionCable.server.broadcast(
        user_channel_name,
        {
            event: "job-application-submitted",
            job_application_id: @job_application.id,
            user_id: @user.id,
            job_id: job.id,
            status: "Applied",
        }
      )
    end

  private

  def assign_values_to_form
    application_criteria = @job_application.job.application_criteria
    custom_fields = {}
    ApplicationResponse.where(job_application_id: @job_application.id).each do |response|
      custom_fields[response.field_name] = response.field_value
    end

    application_criteria.each do |key, value|
      if @user.respond_to?(key) && @user.send(key).present?
        application_criteria[key]['value'] = user.send(key)
      else
        application_criteria[key]['value'] = custom_fields[key]
        # p "Warning: defaults does not have a method or attribute '#{key}'. Using NIL value instead"
        # application_criteria[key]['value'] = nil
      end
    end
    application_criteria
  end
  end
end
