class JobApplicationsController < ApplicationController
  # before_action :authenticate_user!, except: [:new]
  # TODO: Update this to allow unregistered users to test job applications
  # TODO: Fix issue with cookies where they are not removed when the user goes back to job_applications/new

  def index
    @job_applications = JobApplication.all.where(user_id: current_user.id)
  end

  def show
    @apps_submitted = JobApplication.where(user_id: current_user.id).all.count
    @hours_saved = (@apps_submitted * 0.2).ceil
    @dog_names = ["Biscuit", "Cookie", "Muffin", "Brownie", "Cupcake", "Pretzel", "Waffle", "Pancake", "Donut"]
  end

  def new
    redirect_back(fallback_location: saved_jobs_path) and return if cookies[:selected_job_ids].nil?

    if current_user.present?
      job_ids = cookies[:selected_job_ids].split("&")
      @selected_jobs = Job.includes(:company).find(job_ids)

      @job_applications = @selected_jobs.map do |job|
        job_application = job.new_job_application_for_user(current_user)
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
    @job_application.status = "Application queued"

    # TODO: Fix as at the moment this logic doesn't work as it is overwritten by the front-end javascript redirects
    if current_user.resume.attached?
      puts "Moving you along the user has a resume attached path."
      # TODO: Add validation to check that the user has filled in their core details
      params[:job_application][:application_responses_attributes].each_value do |response_attributes|
        next unless response_attributes[:field_name] == "cover_letter_"

        cover_letter_content = response_attributes[:cover_letter_content]
        next unless cover_letter_content

        p "Cover letter content present"
        @job_application.application_responses.each do |response|
          response.field_value = cover_letter_content if response.field_name == "cover_letter_"
        end
      end

      if @job_application.save

        p "Job application saved."

        user_channel_name = "job_applications_#{current_user.id}"
        user_saved_jobs = SavedJob.where(user_id: current_user.id)
        user_saved_jobs.find_by(job_id: @job_application.job.id).destroy
        ActionCable.server.broadcast(
          user_channel_name,
          {
            event: "job-application-created",
            job_application_id: @job_application.id,
            # user_id: @job_application.user_id,
            job_id: @job_application.job_id,
            status: @job_application.status
          }
        )

        ApplyJob.perform_now(@job_application.id, current_user.id)
        @job_application.update(status: "Application pending")

        ActionCable.server.broadcast(
          user_channel_name,
          {
            event: "job-application-submitted",
            job_application_id: @job_application.id,
            user_id: @job_application.user_id,
            job_id: @job_application.job_id,
            status: @job_application.status
            # Include any additional data you want to send to the frontend
          }
        )

        p "Job Application Status: #{@job_application.status}"

        ids = cookies[:selected_job_ids].split("&")
        ids.delete(job.id.to_s)

        p "IDs: #{ids}"

        # Believe this automatically adds & between the cookies?
        cookies[:selected_job_ids] = ids

        p "Cookies: #{cookies[:selected_job_ids]}"
        # Not necessary to redirect after each individual #create
        # redirect_to job_applications_path, notice: 'Your applications have been submitted.'
      else
        # p "Rendering new"
        render :new
        p "Couldn't save job application."
      end
    else
      # p "User doesn't have a resume attached."
      redirect_to edit_user_registration_path(current_user),
                  alert: 'Please update your core details and attach a CV before applying.'
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
    params.require(:job_application).permit(application_responses_attributes: [:field_name, { field_value: [] },
                                                                               :field_value, :field_locator, :interaction, :field_option, :field_options, :cover_letter_content, :required])
  end
end
