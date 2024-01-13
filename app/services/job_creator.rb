class JobCreator
  include Ats::AtsHandler

  def check_job_is_live
    uri = URI(@url)
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPRedirection)
      p "Job is not live"
      @job.job_title = 'Job is no longer live'
      @job.job_description = 'Job is no longer live'
      @job.live = false
    else
      p "Job is live"
      @job.live = true
    end
    @job.live
  end

  def pull_job_details
    if ats_system
      ats_module.get_job_details(@job)
    else
      p "Unable to detect ATS system for URL: #{@url}"
      return nil
    end
  end
end
