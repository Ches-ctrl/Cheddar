class JobsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:query].present?
      @jobs = Job.global_search(params[:query])
      @initial_jobs = Job.global_search(params[:query]).limit(10)
      @remaining_jobs = Job.global_search(params[:query]).offset(10)
    else
      @jobs = Job.all
      @initial_jobs = Job.limit(10)
      @remaining_jobs = Job.offset(10)
    end
    @job = Job.new
    @saved_job = SavedJob.new
    @saved_jobs = SavedJob.all
    @job_applications = JobApplication.where(user_id: current_user.id)
  end

  def show
    @job = Job.find(params[:id])
    @saved_job = SavedJob.new
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      redirect_to job_path(@job), notice: 'Job was successfully added'
    else
      @jobs = Job.all
      render 'jobs/index', status: :unprocessable_entity
    end
  end

  def apply_to_selected_jobs
    # Fetch the selected job IDs from the parameters
    p params
    selected_job_ids = params[:job_ids]
    p cookies[:selected_job_ids]
    p selected_job_ids

    # Instead of directly creating job applications, store the selected jobs in the session or another temporary store
    cookies[:selected_job_ids] = selected_job_ids
    # raise
    # Redirect to a new action that will display the staging page
    redirect_to new_job_application_path
  end

  private

  def job_params
    params.require(:job).permit(:job_title, :job_description, :salary, :job_posting_url, :application_deadline, :date_created, :company_id)
  end
end

# def apply_to_selected_jobs
#   selected_job_ids = params[:job_ids]
#   selected_job_ids.each do |job_id|
#     job_app = JobApplication.create(job_id: job_id, user_id: current_user.id, status: "Pre-application")
#     ApplyJob.perform_now(job_app.id, current_user.id)
#     # flash[:notice] = "You applied to #{Job.find(job_id).job_title}!"
#   end
#   redirect_to job_applications_path
# end
