class AddJobToCheddarJob < ApplicationJob
  queue_as :default

  def perform(url, company)
    p "----------------"
    p "----------------"
    p "----------------"
    p "----------------"
    p "Hello from the AddJobToCheddar background job!"

    # Company already created, so don't need to create it again, can pass that as an argument
    # Create job with job_posting_url via JobCreator

    job = Job.new(
      job_title: "Job Title Placeholder",
      job_posting_url: url,
      company_id: company.id,
    )
  
    p "Job posting url: #{job.job_posting_url}"
  
    job = JobCreator.new(job).add_job_details

    p "****************"
    p "****************"
    p "****************"
    p "****************"

    "Job title: #{job.job_title}"

    # p job
    
    job.save
    
    p "Created job - #{Job.last.job_title}"


    # if @job.save
    #   AddJobToCheddarJob.perform_later(@job)
    #   redirect_to job_path(@job), notice: 'Job was successfully added'
    # else
    #   # What should happen if the job doesn't save?
    #   render :new
    # end
  end

  # Peusdocode:
  # 1. User goes to a webpage for a job that isn't listed on Cheddar
  # 2. User copies the URL into a space on Cheddar that initialises this background job
  # 3. The background job scrapes the URL and adds the wireframed job to Cheddar
end
