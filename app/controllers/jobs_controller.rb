class JobsController < ApplicationController
  require 'cgi'
  include ActionView::Helpers::SanitizeHelper

  before_action :authenticate_user!, except: %i[index show]
  before_action :job_show_page_status, only: [:show]
  before_action :set_saved_jobs, only: [:index]
  before_action :set_job_applications, only: [:index]

  # TODO: Sort in filter

  def index
    filtered_jobs = JobFilter.new(params).filter_and_sort

    @jobs = filtered_jobs.includes(associated_tables)
                         .order(sort_order(params[:sort]))
                         .page(params[:page])
                         .per(20)

    @resources, @total_jobs = CategorySidebar.new(filtered_jobs, params).build
  end

  def show
    @job = Job.find(params[:id])
    @company = @job.company
    @saved_job = SavedJob.new
    @description = sanitize(@job.description).html_safe
  end

  def add_job
    @job = Job.new
  end

  private

  def set_saved_jobs
    return unless current_user.present?

    @saved_jobs = SavedJob.all
    @saved_job_ids = @saved_jobs.to_set(&:job_id)
  end

  def set_job_applications
    @job_applications = JobApplication.where(user_id: current_user.id) if current_user.present?
  end

  def associated_tables
    params[:location] == 'remote' ? %i[requirement company] : %i[requirement company locations]
  end

  def sort_order(sort_param)
    sort_options = {
      'title' => 'jobs.title ASC',
      'title_desc' => 'jobs.title DESC',
      'company' => 'companies.name ASC',
      'company_desc' => 'companies.name DESC',
      'created_at' => 'jobs.created_at DESC',
      'created_at_asc' => 'jobs.created_at ASC'
    }.freeze

    sort_options.fetch(sort_param, 'jobs.created_at DESC')
  end

  def job_show_page_status
    redirect_to jobs_path, notice: 'Job show page coming soon!' unless Flipper.enabled?(:job_show_page)
  end

  def job_params
    params.require(:job).permit(:title, :description, :salary, :posting_url, :deadline, :date_posted, :company_id, :applicant_tracking_system_id, :ats_job_id, :non_geocoded_location_string, :department, :office, :live)
  end
end
