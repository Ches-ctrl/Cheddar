class ApplicationSubmissionsController < ApplicationController
  def create
    load_application_process
    # enqueue_job_application
    assign_statuses
    persist_application_process_and_job_applications
  end

  private

  def application_submissions_params
    params.permit(:application_process_id)
  end

  def assign_statuses
    @application_process.assign_attributes(status: :submitted)
    @job_applications = @application_process.job_applications.map do |job_application|
      job_application.assign_attributes(submissions_params)
      job_application
    end
  end

  def load_application_process
    @application_process = ApplicationProcess.eager_load(:job_applications)
                                             .find(application_submissions_params[:application_process_id])
  end

  def persist_application_process_and_job_applications
    if @application_process.save && @job_applications.each(&:save!)
      redirect_to in_progress_jobs_path, notice: 'Job applications successfully submitted!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def submissions_params
    { status: :submitted, submitted_at: Time.now }
  end
  # def enqueue_job_application
  #   Applier::ApplyJob.perform_later(@job_application, submit_application_params[:payload])
  # end
end
