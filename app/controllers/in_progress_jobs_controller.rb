class InProgressJobsController < SavedJobsController
  def index
    load_jobs
  end

  private

  def load_jobs
    @saved_jobs = OpportunitiesFetcher.call(jobs_scope, job_params)
    @pagy, @records = pagy(@saved_jobs, items: 20)
  end

  def job_params
    params.permit(:page)
  end

  def jobs_scope
    Job.where(id: current_user.job_applications.in_progress.pluck(:job_id))
  end
end
