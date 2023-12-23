class JobsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :apply_to_selected_jobs]

  def index
    # TODO: Fix search functionality so that 20 jobs are always shown

    if params[:query].present?
      @jobs = Job.global_search(params[:query])
      @initial_jobs = Job.global_search(params[:query]).limit(20)
      @remaining_jobs = Job.global_search(params[:query]).offset(20)
    else
      @jobs = Job.all
      @initial_jobs = Job.limit(20)
      @remaining_jobs = Job.offset(20)
    end
    @job = Job.new
    @saved_job = SavedJob.new
    @saved_jobs = SavedJob.all
    if current_user.present?
      @job_applications = JobApplication.where(user_id: current_user.id)
    end
    # TODO: Check this is setup correctly
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
    selected_job_ids = params[:job_ids]
    cookies[:selected_job_ids] = selected_job_ids

    # TODO: Check if user has filled in their core details, if not redirect to edit their information, then redirect to new_job_application_path
    redirect_to new_job_application_path
  end

  def find_job_application
    user_id = params[:user_id]
    job_id = params[:id]

    p "+++++++++++++++++++++++"
    p "+++++++++++++++++++++++"
    p "+++++++++++++++++++++++"
    p "+++++++++++++++++++++++"

    p "User ID: #{user_id}"
    p "Job ID: #{job_id}"

    job_application = JobApplication.find_by(user_id: user_id, job_id: job_id)

    p "Job Application: #{job_application}"

    if job_application
      render json: job_application
    else
      render json: { error: 'Job application not found' }, status: :not_found
    end
  end

  private

  # TODO: Check if more params are needed

  def job_params
    params.require(:job).permit(:job_title, :job_description, :salary, :job_posting_url, :application_deadline, :date_created, :company_id, :applicant_tracking_system_id, :ats_format_id)
  end
end
