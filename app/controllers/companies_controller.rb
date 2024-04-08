class CompaniesController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  skip_before_action :authenticate_user!

  def show
    @company = Company.find(params[:id])
    @jobs = @company.jobs
    @company_description = sanitize @company.description
  end
end
