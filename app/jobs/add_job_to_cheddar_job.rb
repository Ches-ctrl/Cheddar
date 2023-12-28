class AddJobToCheddarJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    p "Hello from the background job!"

    # @company = CompanyCreator.new(url).find_or_create_company
    # @job = Job.new(job_params, company_id: @company.id)

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
