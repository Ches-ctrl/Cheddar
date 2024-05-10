class CompaniesController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  skip_before_action :authenticate_user!
  before_action :company_show_page_status, only: [:show]

  def show
    @company = Company.find(params[:id])
    @jobs = @company.jobs
    @company_description = sanitize @company.description
  end

  private

  def company_show_page_status
    redirect_to jobs_path, notice: "Company show page coming soon!" unless Flipper.enabled?(:company_show_page)
  end
end
