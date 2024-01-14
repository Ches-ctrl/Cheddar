class JobCreator
  include AtsRouter

  def check_job_is_live
    uri = URI(@url)
    response = Net::HTTP.get_response(uri)

    # TODO: Add additional logic for checking job is live
    if response.is_a?(Net::HTTPRedirection)
      @job.job_title = 'Job is no longer live'
      @job.job_description = 'Job is no longer live'
      @job.live = false
    else
      @job.live = true
    end
  end

  def find_or_create_job
    if ats_system_name
      # ats_system
      ats_module('JobDetails').get_job_details(@job)
    else
      p "Unable to detect ATS system for URL: #{@url}"
      return nil
    end
  end
end
