class JobApplicationsController < ApplicationController

  def index
    @job_applications = JobApplication.all.where(user_id: current_user.id)
  end

  def show
  end

  def new
    @selected_jobs = Job.find(cookies[:selected_job_ids].split("&"))

    @job_applications = @selected_jobs.map do |job|
      job_application = JobApplication.new(user: current_user, status: "Pre-application")

      job.application_criteria.each do |field, details|
        application_response = job_application.application_responses.build
        application_response.field_name = field
        application_response.field_locator = details["locators"]
        application_response.interaction = details["interaction"]
        application_response.field_option = details["option"]
        application_response.field_value = current_user.try(field) || ""
        p application_response
      end

      [job, job_application]
    end
    # Renders the staging page where the user can review and confirm applications
  end

  # TODO: Split out core application criteria that is common to all job applications
  # TODO: Split out additional application criteria that is specific to the job
  # TODO: only be able to make a job application if you haven't already applied to the job

  def create
    job = Job.find(params[:job_id])

    @job_application = JobApplication.new(job_application_params)
    @job_application.user = current_user
    @job_application.job = job
    @job_application.status = "Application pending"

    if @job_application.save
      # TODO: Move this to be a service that we wait for when the user is applying? At the moment we don't validate the application

      ApplyJob.perform_later(@job_application.id, current_user.id)
      @job_application.update(status: "Applied")

      ids = cookies[:selected_job_ids].split("&")
      ids.delete("#{job.id}")

      # Believe this automatically adds & between the cookies?
      cookies[:selected_job_ids] = ids

      redirect_to job_applications_path, notice: 'Your applications have been submitted.'
    else
      render :new
    end
  end

  def success
  end

  private

  # TODO: Update job_application_params to include the user inputs

  def job_application_params
    params.require(:job_application).permit(application_responses_attributes: [:field_name, :field_value, :field_locator, :interaction, :field_option])
  end
end
