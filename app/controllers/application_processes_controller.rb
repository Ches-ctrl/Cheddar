class ApplicationProcessesController < ApplicationController
  def create
    build_application_process
    build_job_applications
    persist_application_process
  end

  private

  def build_application_process
    @application_process = current_user.application_processes.new
  end

  def build_job_applications
    @job_applications = job_applications_params[:job_ids].map do |job_id|
      @application_process.job_applications.new(job_id:)
    end
  end

  def job_applications_params
    params.except(:authenticity_token).permit(job_ids: [])
  end

  def persist_application_process
    if @application_process.save && call_service
      render_application_process
    else
      render_application_process_error
    end
  end

  def render_application_process
    redirect_to new_job_application_path(@job_applications.first), notice: 'Your application process was successfully created'
  end

  def render_application_process_error
    render :new, status: :unprocessable_entity
  end

  # TODO : create separate server
  def call_service
    SavedJob.where(job_id: job_applications_params[:job_ids]).delete_all
  end
end
