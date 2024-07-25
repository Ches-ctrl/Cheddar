class PayloadApplicationProcessesController < ApplicationProcessesController
  before_action :require_admin

  def index
    load_application_process
  end

  def show
    load_job_application
  end

  private

  def load_job_application
    @job_application = JobApplication.find_by(id: payload_params[:job_application_id])
  end

  def payload_params
    params.permit(:application_process_id, :job_application_id)
  end

  def require_admin
    redirect_to root_path, alert: "You are not authorized to perform this action." unless current_user.admin?
  end
end
