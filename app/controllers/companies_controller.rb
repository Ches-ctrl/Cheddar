class CompaniesController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  skip_before_action :authenticate_user!
  before_action :set_company, only: [:show, :filter_jobs]
  before_action :set_jobs_and_departments, only: [:show, :filter_jobs]

  def show
    @company_description = sanitize @company.description
  end

  def filter_jobs
    @jobs = JobFilteringService.new(@jobs, filter_params).filter_by_department
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def set_jobs_and_departments
    @jobs = @company.jobs
    set_departments
  end

  def set_departments
    @departments = @jobs.pluck(:department).compact.uniq
  end

  def filter_params
    params.permit(:department)
  end
end
