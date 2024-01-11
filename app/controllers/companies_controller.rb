class CompaniesController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  def show
    @company = Company.find(params[:id])
    @jobs = @company.jobs
    p @company.description
    @company_description = sanitize @company.description
    p @company_description
  end
end
