class JobApplicationsController < ApplicationController
  # before_action :authenticate_user!, except: [:new]
  # TODO: Update this to allow unregistered users to test job applications

  def index
    @job_applications = JobApplication.all.where(user_id: current_user.id)
  end

  def show
  end

  def new
    if current_user.present?
      @selected_jobs = Job.find(cookies[:selected_job_ids].split("&"))

      @job_applications = @selected_jobs.map do |job|
        job_application = JobApplication.new(user: current_user, status: "Pre-application")

        job.application_criteria.each do |field, details|
          application_response = job_application.application_responses.build
          application_response.field_name = field
          application_response.field_locator = details["locators"]
          application_response.interaction = details["interaction"]
          application_response.field_option = details["option"]

          if details["options"].present?
            application_response.field_options = details["options"]
          end
          application_response.field_value = current_user.try(field) || ""
        end

        [job, job_application]
      end
      # Renders the staging page where the user can review and confirm applications
    else
      @selected_jobs = Job.find(cookies[:selected_job_ids].split("&"))
      flash[:alert] = "You need to be logged in to create job applications."
    end
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

    # TODO: Fix as at the moment this logic doesn't work as it is overwritten by the front-end javascript redirects
    if current_user.resume.attached?
      puts "Moving you along the user has a resume attached path."
      # TODO: Add validation to check that the user has filled in their core details

      if @job_application.save
        p "======================="
        p "======================="
        p "======================="
        p "======================="
        p "======================="

        p "Performing ApplyJob"

        # ApplyJob.perform_later(@job_application.id, current_user.id)
        @job_application.update(status: "Applied")

        p "Job Application Status: #{@job_application.status}"

        ids = cookies[:selected_job_ids].split("&")
        ids.delete("#{job.id}")

        p "IDs: #{ids}"

        # Believe this automatically adds & between the cookies?
        cookies[:selected_job_ids] = ids

        p "Cookies: #{cookies[:selected_job_ids]}"

        redirect_to job_applications_path, notice: 'Your applications have been submitted.'
      else
        p "Rendering new"
        render :new
      end
    else
      puts "User doesn't have a resume attached."
      redirect_to edit_user_registration_path(current_user), alert: 'Please update your core details and attach a CV before applying.'
      return
    end
  end

  # def status
  #   # TODO: JobApplication won't be in params as it hasn't been created yet - needs to be retried based on the job and user ids
  #   job_application = JobApplication.find(params[:id])
  #   p "Job Application: #{job_application}"
  #   # You need to implement the logic here to check the status of job_application
  #   # You can use job_application.status or any other method to determine the status
  #   # You should return a JSON response with the status
  #   # TODO: Install sidekiq status gem and use this to check the status of the job application
  #   status = job_application.status
  #   p "Job Application Status: #{status}"
  #   render json: { status: status }
  # end

  def success
  end

  private

  # TODO: Update job_application_params to include the user inputs

  def job_application_params
    params.require(:job_application).permit(application_responses_attributes: [:field_name, :field_value, :field_locator, :interaction, :field_option, :field_options])
  end
end
