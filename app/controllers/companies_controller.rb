class CompaniesController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  skip_before_action :authenticate_user!
  before_action :company_show_page_status, only: [:show]
  before_action :set_company, only: %i[show]
  before_action :set_jobs_and_departments, only: %i[show]

  def show
    @company_description = sanitize @company.description
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def filter_jobs
    @jobs = JobFilteringService.new(@jobs, filter_params).filter_by_department
  end

  def set_jobs_and_departments
    @jobs = @company.jobs
    set_departments
    filter_jobs
  end

  def set_departments
    @departments = @jobs.pluck(:department).compact.uniq
  end

  def filter_params
    params.permit(:department)
  end

  def company_show_page_status
    redirect_to jobs_path, notice: "Company show page coming soon!" unless Flipper.enabled?(:company_show_page)
  end
end
