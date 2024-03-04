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

    # For each resource, store: [display_name, element_id, matching_jobs_count]
    @companies = @jobs.map(&:company)
    @companies = @companies.map { |company| [company.company_name, company.id, @companies.count(company)] }.sort_by{ |list| list[2] }.reverse.uniq

    @locations = @jobs.select { |job| job.city.present? && !job.city.include?("Remote") }.map { |job| [(job.city unless job.city == "#{job.country} (Remote)"), job.country].compact }
    @locations += @jobs.select { |job| job.remote_only }.map { |job| ["Remote Only"] }
    @locations = @locations.map { |location| [location.join(', '), location.first.downcase.gsub(' ', '_'), @locations.count(location)] }.sort_by{ |list| list[2] }.reverse.uniq

    @roles = @jobs.map { |job| job.role.split('&&') if job.role }.flatten.compact
    @roles = @roles.map { |role| [role.split('_').map(&:titleize).join('-'), role, @roles.count(role)] }.sort_by{ |list| list[2] }.reverse.uniq

    @seniorities = ['Internship', 'Entry-Level', 'Junior', 'Mid-Level', 'Senior', 'Director', 'VP', 'SVP / Partner']
    @seniorities = @seniorities.map { |seniority| [seniority, seniority.downcase.split(' ').first, @jobs.count { |job| job.seniority == seniority }] }.reject { |list| list[2].zero? }

    @employments = @jobs.map(&:employment_type)
    @employments = @employments.map { |employment| [employment, employment.downcase.gsub('-', '_'), @employments.count(employment)] }.sort_by{ |list| list[2] }.reverse.uniq

    if params[:role].present?
      roles = params[:role].split
      conditions = roles.map { |role| "role LIKE ?" }.join(" OR ")
      values = roles.map { |role| "%#{role}%" }

      @jobs = @jobs.where(conditions, *values)
    end

    if params[:company].present?
      companies = params[:company].split
      @jobs = @jobs.where(company: companies)
    end

    if params[:location].present?
      locations = params[:location].split.map { |location| location.gsub('_', ' ').split.map(&:capitalize).join(' ') }
      if locations.include?("Remote Only")
        @jobs = @jobs.where("city IN (?) OR country IN (?) OR remote_only = TRUE", locations, locations)
      else
        @jobs = @jobs.where("city IN (?) OR country IN (?)", locations, locations)
      end
    end

    if params[:seniority].present?
      seniorities = params[:seniority].split.map { |seniority| seniority.split('-').map(&:capitalize).join('-') }
      @jobs = @jobs.where(seniority: seniorities)
    end

    if params[:employment].present?
      employments = params[:employment].split.map { |employment| employment.gsub('_', '-').capitalize }
      @jobs = @jobs.where(employment_type: employments)
    end

    @jobs = @jobs.paginate(page: params[:page], per_page: 20)

    @job = Job.new # why do we have this here?
    @saved_job = SavedJob.new # why initialize SavedJob here?
    @saved_jobs = SavedJob.all
    @saved_job_ids = @saved_jobs.map(&:job_id).to_set

    if current_user.present?
      @job_applications = JobApplication.where(user_id: current_user.id)
    end

    # Implemented pgsearch, this will be uncommented once the index action is cleaned up.
    # @jobs = if params[:query].present?
    #           Job.search_job(params[:query])
    #         else
    #           Job.all
    #         end
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

  # TODO: Check if more params are needed on Job.create

  def job_params
    params.require(:job).permit(:job_title, :job_description, :salary, :job_posting_url, :application_deadline, :date_created, :company_id, :applicant_tracking_system_id, :ats_job_id, :location, :department, :office, :live)
  end
end
