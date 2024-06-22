class SavedJobsController < ApplicationController
  include Pagy::Backend

  def index
    load_saved_jobs
  end

  def create
    build_saved_job
    persist_saved_job
  end

  def destroy
    load_saved_job
    destroy_saved_job
  end

  private

  def build_saved_job
    @saved_job = current_user.saved_jobs.new(job_id: saved_job_params[:opportunity_id])
  end

  def destroy_saved_job
    if @saved_job.destroy
      success_deleted_job_redirect_to_referrer
    else
      error_redirect_to_referrer
    end
  end

  def load_saved_job
    @saved_job = current_user.saved_jobs.find_by(job_id: saved_job_params[:opportunity_id])
  end

  def load_saved_jobs
    @saved_jobs = OpportunitiesFetcher.call(saved_jobs_scope, saved_job_params)
    @pagy, @records = pagy(@saved_jobs, items: 20)
  end

  def persist_saved_job
    if @saved_job.save
      success_saved_job_redirect_to_referrer
    else
      error_redirect_to_referrer
    end
  end

  def saved_jobs_scope
    Job.where(id: current_user.saved_jobs.pluck(:job_id))
  end

  def success_saved_job_redirect_to_referrer
    redirect_to request.referrer, notice: 'Job successfully saved!'
  end

  def success_deleted_job_redirect_to_referrer
    redirect_to request.referrer, notice: 'Job successfully unsaved!'
  end

  def error_redirect_to_referrer
    redirect_to request.referrer, alert: 'Something went wrong, please try again'
  end

  def saved_job_params
    params.permit(:opportunity_id, :page)
  end
end
