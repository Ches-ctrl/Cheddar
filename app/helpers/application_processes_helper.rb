module ApplicationProcessesHelper
  def current_application_process(jobs)
    current_user.application_processes
                .eager_load(:job_applications)
                .find_by('job_applications.job_id': jobs.last.id)
  end
end
