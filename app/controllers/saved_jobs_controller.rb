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
      success_redirect_to_referrer('Job successfully unsaved!')
    else
      error_redirect_to_referrer('Something went wrong, please try again')
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
      success_redirect_to_referrer('Job successfully saved!')
    else
      error_redirect_to_referrer('Something went wrong, please try again')
    end
  end

  def saved_jobs_scope
    Job.where(id: current_user.saved_jobs.pluck(:job_id))
  end

  def saved_job_params
    params.permit(:opportunity_id, :page)
  end
end
