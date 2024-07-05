class InProgressJobsController < SavedJobsController
  include Pagy::Backend

  def index
    load_in_progress_jobs
  end

  private

  def load_in_progress_jobs
    @saved_jobs = OpportunitiesFetcher.call(in_progress_jobs_scope, in_progress_job_params)
    @pagy, @records = pagy(@saved_jobs, items: 20)
  end

  def in_progress_jobs_scope
    Job.where(id: current_user.job_applications.pluck(:job_id))
  end

  def in_progress_job_params
    params.permit(:page)
  end
end
