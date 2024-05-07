require 'cgi'

class JobsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  before_action :authenticate_user!, except: %i[index show apply_to_selected_jobs]
  before_action :job_show_page_status, only: [:show]

  def index
    @jobs = Job.filter_and_sort(params).paginate(page: params[:page], per_page: 20)
    @resources = CategorySidebar.build_with(@jobs, params)

    @saved_jobs = SavedJob.all
    @saved_job_ids = @saved_jobs.to_set(&:job_id)

    @job_applications = JobApplication.where(user_id: current_user.id) if current_user.present?

    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
    @job = Job.find(params[:id])
    @company = @job.company
    @saved_job = SavedJob.new
    @description = sanitize @job.description
  end

  def add_job
    @job = Job.new
  end

  private

  # TODO: Remove #create and #job_params?

  def job_params
    params.require(:job).permit(:title, :description, :salary, :posting_url, :deadline, :date_posted, :company_id, :applicant_tracking_system_id, :ats_job_id, :non_geocoded_location_string, :department, :office, :live)
  end
end
