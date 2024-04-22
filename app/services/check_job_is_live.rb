class CheckJobIsLive
  # NB. Not tested yet
  # Does all jobs at the moment
  # TODO: set up a cron job to run this every day?

  # Pseudocode:
  # 1. For each job in the database, get the posting_url
  # 2. Go to posting_url and check if the job is still live
  # 3. If the job is no longer live, set job.live = false
  # 4. If the job is still live, set job.live = true
  # 5. If the posting_url is no longer valid, set job.live = false

  def check_job_is_live
    Job.all.each do |job|
      posting_url = job.posting_url
      job_live = check_if_job_is_live(posting_url)

      # 3. If the job is no longer live, set job.live = false
      # 4. If the job is still live, set job.live = true
      job.live = job_live

      # 5. If the posting_url is no longer valid, set job.live = false
      job.live = false if job_posting_url_invalid?(posting_url)

      # Save the changes to the job
      job.save
    end
  end

  private

  def check_if_job_is_live(posting_url)
    # You can use any method to check if the job is still live, such as making an HTTP request
    # Implement your logic to check if the job is still live
    # Return true if the job is live, false otherwise
  end

  def job_posting_url_invalid?(posting_url)
    # Implement your logic to check if the posting_url is no longer valid
    # Return true if the posting_url is invalid, false otherwise
  end
end
