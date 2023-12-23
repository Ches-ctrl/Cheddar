class ApplyJob < ApplicationJob
  include Defaults::DefaultMale
  include Defaults::DefaultFemale

  queue_as :default
  sidekiq_options retry: false

  def perform(job_application_id, user_id)
    job = JobApplication.find(job_application_id).job
    user = User.find(user_id)

    application_criteria = assign_values_to_form(job, user)
    fields_to_fill = application_criteria

    form_filler = FormFiller.new
    form_filler.fill_out_form(job.job_posting_url, fields_to_fill, job_application_id)

    Capybara.send(:session_pool).each { |name, ses| ses.driver.quit }
    p "You applied to #{job.job_title}!"
  end

  private

  def assign_values_to_form(job, user)
    application_criteria = job.application_criteria

    application_criteria.each do |key, value|
      if user.respond_to?(key) && user.send(key).present?
        p "Using USER value for #{key}"
        application_criteria[key]['value'] = user.send(key)
      elsif DEFAULT_MALE.key?(key) && DEFAULT_MALE[key].key?('value')
        p "Warning: User does not have a method or attribute '#{key}'. Using DEFAULT value instead"
        application_criteria[key]['value'] = DEFAULT_MALE.dig(key, 'value')
      else
        p "Warning: defaults does not have a method or attribute '#{key}'. Using NIL value instead"
        application_criteria[key]['value'] = nil
      end
    end
    p "Application criteria with values: #{application_criteria}"
    return application_criteria
  end
end
