class SubmitApplicationController < ApplicationController
  def create
    p "Submitting job application"
    load_job_application
    enqueue_job_application
  end

  private

  def load_job_application
    @job_application = JobApplication.find(submit_application_params[:job_application_id])
  end

  def enqueue_job_application
    Applier::ApplyJob.perform_later(@job_application, submit_application_params[:payload])
  end

  def submit_application_params
    # byebug
    params.require(:job_application).permit(:job_application_id, :payload)
  end
end
