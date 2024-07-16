module ApplicationProcessesHelper
  def current_application_process(jobs)
    current_user.application_processes
                .eager_load(:job_applications)
                .find_by('job_applications.job_id': jobs.last.id)
  end

  def current_application_step?(step_id)
    (current_controller?("application_processes") && step_id.eql?("common_fields")) ||
      (current_controller?("overview_application_processes") && step_id.eql?("overview")) ||
      (current_controller?("payload_application_processes") && step_id.eql?("payload")) ||
      (current_controller?("job_applications") && request.fullpath.include?("job_applications/#{step_id}"))
  end

  def application_step_completed?(step_id)
    (current_controller?("job_applications") && step_id.eql?("common_fields")) ||
      (current_controller?("overview_application_processes") && !step_id.eql?("payload")) ||
      current_controller?("payload_application_processes") ||
      comes_before?(step_id, params[:id].to_i)
  end

  def application_step_unstarted?(_step_id)
    true
  end

  def job_application_by_job(jobs, job)
    current_application_process(jobs)
      .job_applications
      .find_by('job_applications.job_id': job.id)
  end

  def first_job_application(jobs)
    ApplicationProcess.find_by(id: current_application_process(jobs).id)
                      .job_applications.first
  end

  def job_application_ids
    @application_process.job_application_ids
  end

  def comes_before?(target, comparison)
    return false unless target.is_a?(Integer)
    return false unless current_controller?("job_applications")

    data = job_application_ids

    data.index(target) < data.index(comparison)
  end

  def prefilled_value(question, job_application)
    filled_value(question, job_application) || user_detail_value(question, job_application)
  end

  def filled_value(question, job_application)
    question.answered_value(job_application)
  end

  def user_detail_value(question, job_application)
    return unless UserDetail::FREQUENT_ASKED_INFO_ATTRIBUTES.include?(question.attribute)

    job_application.application_process.user.user_detail.public_send(question.attribute)
  end
end
