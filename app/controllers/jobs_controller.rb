class JobsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  before_action :authenticate_user!, except: [:index, :show, :apply_to_selected_jobs]

  def index
    # TODO: Refactor entire index action, should be 5 lines max
    # TODO: Fix search functionality so that 20 jobs are always shown
    # TODO: Install Kaminari to fix long page load time on index page and add pagination
    # TODO: Add bullet gem to detect N+1 queries, implement pagination
    # TODO: Implement pagination for the remaining jobs

    @jobs = Job.where.not(location: "").includes(:company)

    # When a job doesn't actually exist, its location is nil.

    build_filter_sidebar_resources
    filter_jobs_by_params

    @jobs = @jobs.paginate(page: params[:page], per_page: 20)

    @saved_jobs = SavedJob.all
    @saved_job_ids = @saved_jobs.map(&:job_id).to_set

    if current_user.present?
      @job_applications = JobApplication.where(user_id: current_user.id)
    end

    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
    @job = Job.find(params[:id])
    @company = @job.company
    @saved_job = SavedJob.new
    @job_description = sanitize @job.job_description
  end

  def new
    @job = Job.new
  end

  def create
    p "Starting Create method"
    @job = Job.new(job_params)

    # TODO: check if job already exists in DB, if so, redirect to job_path(@job)
    # TODO: convert job_posting_url to standard format

    p "Starting CompanyCreator"
    company, ats_job_id = CompanyCreator.new(@job.job_posting_url).find_or_create_company
    p "CompanyCreator complete: #{company.company_name}"

    @job.company_id = company.id
    @job.applicant_tracking_system_id = company.applicant_tracking_system_id
    @job.ats_job_id = ats_job_id

    p "Starting JobCreator"
    JobCreator.new(@job).add_job_details
    if @job.save
      p "Saved job - #{@job.job_title}"
      redirect_to job_path(@job), notice: 'Job was successfully added'
    else
      p "Job not saved"
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

  def add
    @job = Job.new
  end

  def add_job
    @job = Job.new
  end

  private

  CONVERT_TO_DAYS = {
    '1-day' => 1,
    '3-days' => 3,
    'this-week' => 7,
    'this-month' => 30
  }

  # TODO: Check if more params are needed on Job.create

  def job_params
    params.require(:job).permit(:job_title, :job_description, :salary, :job_posting_url, :application_deadline, :date_created, :company_id, :applicant_tracking_system_id, :ats_job_id, :location, :department, :office, :live)
  end

  def filter_jobs_by_params
    filter_by_query if params[:query].present?
    filter_by_when_posted if params[:posted].present?
    filter_by_seniority if params[:seniority].present?
    filter_by_employment if params[:employment].present?
    filter_by_location if params[:location].present?
    filter_by_role if params[:role].present?
    filter_by_company if params[:company].present?
  end

  def filter_by_query
    @jobs = Job.search_job(params[:query]).includes(:company)
  end

  def filter_by_when_posted
    params[:posted].split.each do |time|
      number = CONVERT_TO_DAYS[time]
      @jobs = Job.where(date_created: number.days.ago..Date.today)
    end
  end

  def filter_by_role
    roles = params[:role].split
    conditions = roles.map { |role| "role ILIKE ?" }.join(" OR ")
    values = roles.map { |role| "%#{role}%" }

    @jobs = @jobs.where(conditions, *values)
  end

  def filter_by_company
    companies = params[:company].split
    @jobs = @jobs.where(company: companies)
  end

  def filter_by_location
    locations = params[:location].split.map { |location| location.gsub('_', ' ').split.map(&:capitalize).join(' ') }
    if locations.include?("Remote Only")
      @jobs = @jobs.where("city IN (?) OR country IN (?) OR remote_only = TRUE", locations, locations)
    else
      @jobs = @jobs.where("city IN (?) OR country IN (?)", locations, locations)
    end
  end

  def filter_by_seniority
    seniorities = params[:seniority].split.map { |seniority| seniority.split('-').map(&:capitalize).join('-') }
    @jobs = @jobs.where(seniority: seniorities)
  end

  def filter_by_employment
    employments = params[:employment].split.map { |employment| employment.gsub('_', '-').capitalize }
    @jobs = @jobs.where(employment_type: employments)
  end

  def build_filter_sidebar_resources
    # Where necessary, parse from Job.attributes
    roles = @jobs.map { |job| job.role.split('&&') if job.role }.flatten.compact

    locations = @jobs.map do |job|
      if job.remote_only
        ["Remote Only"]
      elsif job.city.present? && !job.city.include?("Remote")
        [(job.city unless job.city == "#{job.country} (Remote)"), job.country].compact
      end
    end

    when_posted = ['1 day ago', '3 days ago', 'This week', 'This month']

    seniorities = ['Internship', 'Entry-Level', 'Junior', 'Mid-Level', 'Senior', 'Director', 'VP', 'SVP / Partner']

    # For each item, store: [display_name, element_id, matching_jobs_count]
    @resources = {}
    @resources['posted'] = when_posted.map do |period|
      id = period.downcase.gsub(' ago', '').gsub(' ', '-')
      count = @jobs.count { |job| job.date_created >= CONVERT_TO_DAYS[id].days.ago }
      [period, id, count] unless count.zero?
    end
    @resources['seniority'] = seniorities.map do |seniority|
      count = @jobs.count { |job| job.seniority == seniority }
      [seniority, seniority.downcase.split.first, count] unless count.zero?
    end.compact
    @resources['location'] = locations.compact.uniq.map do |location|
      [location.join(', '), location.first.downcase.gsub(' ', '_'), locations.count(location)]
    end
    @resources['role'] = roles.uniq.map do |role|
      [role.split('_').map(&:titleize).join('-'), role, roles.count(role)]
    end
    @resources['employment'] = @jobs.map(&:employment_type).uniq.map do |employment|
      [employment, employment.downcase.gsub('-', '_'), @jobs.count { |job| job.employment_type == employment }]
    end
    @resources['company'] = @jobs.map(&:company).uniq.map do |company|
      [company.company_name, company.id, @jobs.count { |job| job.company == company }]
    end

    @resources.each { |title, array| array.sort_by! { |item| [-item[2]] } unless title == 'seniority' }

  end
end
