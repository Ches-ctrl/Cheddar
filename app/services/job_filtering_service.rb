# app/services/job_filtering_service.rb
class JobFilteringService
  def initialize(jobs, params)
    @jobs = jobs
    @params = params
  end

  def filter_by_department
    @jobs = @jobs.where(department: @params[:department]) if @params[:department].present?
    @jobs
  end
end