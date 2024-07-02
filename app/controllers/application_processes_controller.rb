class ApplicationProcessesController < ApplicationController
  def create
    build_application_process
    build_job_applications
    persist_application_process
  end

  def show
    load_application_process
  end

  private

  def application_process_id
    params.permit(:id)[:id] ||
      params.permit(:application_process_id)[:application_process_id]
  end

  def application_process_scope
    current_user.application_processes
  end

  def build_application_process
    @application_process = current_user.application_processes.new
  end

  def build_job_applications
    @job_applications = job_applications_params[:job_ids].map do |job_id|
      @application_process.job_applications.new(job_id:, additional_info: { email: @application_process.user.user_detail.email })
    end
  end

  def load_application_process
    @application_process = ApplicationProcessesQuery.call(application_process_scope)
                                                    .find_by(id: application_process_id)
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
    redirect_to edit_application_process_job_application_path(@application_process, @job_applications.first), notice: 'Your application process was successfully created'
  end

  def render_application_process_error
    render :new, status: :unprocessable_entity
  end

  # TODO : create separate service class to hold this in time
  def call_service
    SavedJob.where(job_id: job_applications_params[:job_ids]).delete_all
  end
end
