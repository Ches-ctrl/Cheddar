class JobsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:query].present?
      @jobs = Job.global_search(params[:query])
      @initial_jobs = Job.global_search(params[:query]).limit(20)
      @remaining_jobs = Job.global_search(params[:query]).offset(20)
    else
      @jobs = Job.all
      @initial_jobs = Job.limit(20)
      @remaining_jobs = Job.offset(20)
    end
    @job = Job.new
    @saved_job = SavedJob.new
    @saved_jobs = SavedJob.all
    @job_applications = JobApplication.where(user_id: current_user.id)
  end

  def show
    @job = Job.find(params[:id])
    @saved_job = SavedJob.new
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      redirect_to job_path(@job), notice: 'Job was successfully added'
    else
      @jobs = Job.all
      render 'jobs/index', status: :unprocessable_entity
    end
  end

  def apply_to_selected_jobs
    # Fetch the selected job IDs from the parameters
    p params
    selected_job_ids = params[:job_ids]
    p cookies[:selected_job_ids]
    p selected_job_ids

    # Instead of directly creating job applications, store the selected jobs in the session or another temporary store
    cookies[:selected_job_ids] = selected_job_ids
    # raise
    # Redirect to a new action that will display the staging page
    redirect_to new_job_application_path
  end

  private

  # TODO: Check if more params are needed

  def job_params
    params.require(:job).permit(:job_title, :job_description, :salary, :job_posting_url, :application_deadline, :date_created, :company_id, :applicant_tracking_system_id, :ats_format_id)
  end
end

# def apply_to_selected_jobs
#   selected_job_ids = params[:job_ids]
#   selected_job_ids.each do |job_id|
#     job_app = JobApplication.create(job_id: job_id, user_id: current_user.id, status: "Pre-application")
#     ApplyJob.perform_now(job_app.id, current_user.id)
#     # flash[:notice] = "You applied to #{Job.find(job_id).job_title}!"
#   end
#   redirect_to job_applications_path
# end


# {"first_name"=>{"interaction"=>"input", "locators"=>"first_name"},
#  "last_name"=>{"interaction"=>"input", "locators"=>"last_name"},
#  "email"=>{"interaction"=>"input", "locators"=>"email"},
#  "phone_number"=>{"interaction"=>"input", "locators"=>"phone"},
#  "resume"=>{"interaction"=>"upload", "locators"=>"button[aria-describedby=\"resume-allowable-file-types\""},
#  "city"=>{"interaction"=>"input", "locators"=>"job_application[location]"},
#  "location_click"=>{"interaction"=>"listbox", "locators"=>"ul#location_autocomplete-items-popup"},
#  "linkedin_profile"=>{"interaction"=>"input", "locators"=>"input[autocomplete=\"custom-question-linkedin-profile\"]"},
#  "personal_website"=>{"interaction"=>"input", "locators"=>"input[autocomplete=\"custom-question-website\"], input[autocomplete=\"custom-question-portfolio-linkwebsite\"]"},
#  "heard_from"=>{"interaction"=>"input", "locators"=>"input[autocomplete=\"custom-question-how-did-you-hear-about-this-job\"]"},
#  "require_visa?"=>{"interaction"=>"input", "locators"=>"textarea[autocomplete=\"custom-question-would-you-need-sponsorship-to-work-in-the-uk-\"]"},
#  "LinkedIn Profile"=>{"interaction"=>"input", "locators"=>"job_application_answers_attributes_0_text_value"},
#  "Website"=>{"interaction"=>"input", "locators"=>"job_application_answers_attributes_1_text_value"},
#  "How did you hear about this job? *"=>{"interaction"=>"input", "locators"=>"job_application_answers_attributes_2_text_value"},
#  "Do you need visa sponsorship now or in the future? *\n    \n    \n    \n\n\n   --"=>
#   {"interaction"=>"select", "locators"=>"job_application_answers_attributes_3_boolean_value", "option"=>"option", "options"=>["--", "Yes", "No"]},
#  "What is your state/province of residence? *"=>{"interaction"=>"input", "locators"=>"job_application_answers_attributes_4_text_value"}}
