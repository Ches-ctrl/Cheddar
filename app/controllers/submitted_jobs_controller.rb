class SubmittedJobsController < InProgressJobsController
  private

  def jobs_scope
    Job.where(id: current_user.job_applications.submitted.pluck(:job_id))
  end
end
