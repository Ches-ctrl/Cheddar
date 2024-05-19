class JobsController < ApplicationController
  require 'cgi'

  include ActionView::Helpers::SanitizeHelper

  before_action :authenticate_user!, except: %i[index show]
  before_action :job_show_page_status, only: [:show]

  def index
    @jobs = jobs_and_associated_tables.filter_and_sort(params).order(sort_order(params[:sort])).page(params[:page]).per(20)
    @resources = CategorySidebar.build_with(params)

    @saved_jobs = SavedJob.all
    @saved_job_ids = @saved_jobs.to_set(&:job_id)

    @job_applications = JobApplication.where(user_id: current_user.id) if current_user.present?
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

  def sort_order(sort_param)
    case sort_param
    when 'title'
      'jobs.title ASC'
    when 'title_desc'
      'jobs.title DESC'
    when 'company'
      'companies.name ASC'
    when 'company_desc'
      'companies.name DESC'
    when 'created_at'
      'jobs.created_at DESC'
    when 'created_at_asc'
      'jobs.created_at ASC'
    else
      'jobs.created_at DESC'
    end
  end

  def job_show_page_status
    redirect_to jobs_path, notice: 'Job show page coming soon!' unless Flipper.enabled?(:job_show_page)
  end

  def job_params
    params.require(:job).permit(:title, :description, :salary, :posting_url, :deadline, :date_posted, :company_id, :applicant_tracking_system_id, :ats_job_id, :non_geocoded_location_string, :department, :office, :live)
  end

  def jobs_and_associated_tables
    associated_tables = params[:location] == 'remote' ? %i[requirement company] : %i[requirement company locations]
    Job.includes(associated_tables)
  end
end
