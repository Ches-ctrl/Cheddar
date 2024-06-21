class JobApplicationsController < ApplicationController
  def new
    load_jobs
  end

  private

  def load_jobs
    @jobs = OpportunitiesQuery.call(job_scope)
                              .where(opportunity_params.to_h.transform_keys('job_ids' => :id))
  end

  def opportunity_params
    params.permit(job_ids: [])
  end

  def job_scope
    JobApplication.find_by(id: params[:format])
                  .application_process
                  .jobs
  end
end

# # before_action :authenticate_user!, except: [:new]
# # TODO: Update this to allow unregistered users to test job applications
# # TODO: Fix issue with cookies where they are not removed when the user goes back to job_applications/new

# def index
#   @job_applications = JobApplication.all.where(user_id: current_user.id, status: "Applied" || "Application pending")
#   @failed_applications = JobApplication.all.where(user_id: current_user.id, status: "Submission failed")
# end

# def show
#   @apps_submitted = JobApplication.where(user_id: current_user.id).all.count
#   @hours_saved = (@apps_submitted * 0.2).ceil
#   @dog_names = ["Biscuit", "Cookie", "Muffin", "Brownie", "Cupcake", "Pretzel", "Waffle", "Pancake", "Donut"]
# end

# def new
#   redirect_back(fallback_location: saved_jobs_path) and return if params[:job_ids].nil?

#   if current_user.present?
#     job_ids = params[:job_ids]
#     @selected_jobs = Job.eager_load(:company).where(id: job_ids)

#     @job_applications = @selected_jobs.map do |job|
#       job_application = current_user.job_applications.build(job:, status: "Pre-application")
#       job.application_criteria.each do |field, details|
#         job_application.application_responses.build(
#           field_name: field,
#           field_label: details["label"],
#           field_locator: details["locators"],
#           interaction: details["interaction"],
#           field_option: details["option"],
#           field_options: details["options"].to_json,
#           required: details["required"],
#           field_value: current_user.try(field) || "",
#           core_field: details["core_field"]
#         )
#       end
#       p job_application.application_responses
#       job_application
#     end
#   else
#     redirect_to new_user_registration_path, alert: 'Please sign up or log in to apply for jobs.'
#   end
# end

# # TODO: Split out core application criteria that is common to all job applications
# # TODO: Split out additional application criteria that is specific to the job
# # TODO: only be able to make a job application if you haven't already applied to the job

# def create
#   Rails.logger.debug "Received params: #{params.inspect}" # Log the incoming parameters
#   p "Starting the create method."
#   job_application = current_user.job_applications.build(job_application_params)
#   job_application.job = Job.find(params[:job_id])
#   job_application.status = "Pre-application"

#   if job_application.save
#     process_application(job_application)
#     # redirect_to saved_jobs_path, notice: 'Job application successfully submitted!'
#   else
#     Rails.logger.debug "Failed to save job application: #{job_application.errors.full_messages.join(', ')}"
#     p "Failed to save: #{job_application.errors.full_messages}"
#     flash[:alert] = 'There was an error submitting your application. Please try again.'
#     render :new, alert: 'There was an error submitting your application. Please try again.'
#   end
# end

# def process_application(job_application)
#   job_application.update(status: "Application pending")
#   Applier::ApplyJob.perform_later(job_application.id, current_user.id)
#   user_saved_jobs = SavedJob.where(user_id: current_user.id)
#   user_saved_jobs.find_by(job_id: job_application.job.id).destroy
#   ActionCable.server.broadcast("job_applications_#{current_user.id}", {
#                                  event: "job-application-submitted",
#                                  job_application_id: job_application.id,
#                                  user_id: current_user.id,
#                                  job_id: job_application.job_id,
#                                  status: job_application.status
#                                })
# end

# # def status
# #   # TODO: JobApplication won't be in params as it hasn't been created yet - needs to be retried based on the job and user ids
# #   job_application = JobApplication.find(params[:id])
# #   p "Job Application: #{job_application}"
# #   # You need to implement the logic here to check the status of job_application
# #   # You can use job_application.status or any other method to determine the status
# #   # You should return a JSON response with the status
# #   # TODO: Install sidekiq status gem and use this to check the status of the job application
# #   status = job_application.status
# #   p "Job Application Status: #{status}"
# #   render json: { status: status }
# # end

# def success
# end

# def manual_submission
#   @url = params[:url]
# end

# private

# # TODO: Update job_application_params to include the user inputs

# def job_application_params
#   params.require(:job_application).permit(
#     :job_id,
#     application_responses_attributes: [
#       :field_name,
#       { field_value: [] },
#       :field_label,
#       :field_value,
#       :field_locator,
#       :interaction,
#       :field_option,
#       :field_options,
#       :required,
#       :core_field
#     ]
#   )
# end
