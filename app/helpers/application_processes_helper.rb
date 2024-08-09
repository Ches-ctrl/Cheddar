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

  def overview_question_label(job_application, attribute)
    job_application.application_question_set.question_by_attribute(attribute).label
  end

  def overview_humanized_value(job_application, attribute, values)
    job_application.application_question_set.question_by_attribute(attribute).option_text_values(values)
  end

  def prefilled_value(question, job_application, last_applicant_answers)
    filled_value(question, job_application) || previously_answered_value(question, last_applicant_answers)
  end

  def filled_value(question, job_application)
    question.answered_value(job_application)
  end

  def previously_answered_value(question, last_applicant_answers)
    return previously_answered_linkedin_value(last_applicant_answers) if question.linkedin_related?

    last_applicant_answers.find { |hash| hash[question.attribute] }&.values&.first
  end

  def previously_answered_linkedin_value(last_applicant_answers)
    last_applicant_answers.find { |hash| hash.keys.first.include?('linkedin') }&.values&.first
  end
end
