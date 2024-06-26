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

  def job_application_ids
    @application_process.job_application_ids
  end

  def comes_before?(target, comparison)
    return false unless target.is_a?(Integer)
    return false unless current_controller?("job_applications")

    data = job_application_ids

    data.index(target) < data.index(comparison)
  end
end
