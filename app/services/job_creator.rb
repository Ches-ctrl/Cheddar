class JobCreator
  include AtsRouter

  def check_existing_job
    existing_job = Job.find_by(job_posting_url: @url)
    if existing_job
      p "Existing job - #{existing_job.job_title}"
      return true
    else
      p "New job - #{job.job_title}"
      return false
    end
  end

  def check_job_is_live
    uri = URI(@url)
    response = Net::HTTP.get_response(uri)

    # TODO: Add additional logic for checking job is live when not a redirect
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
      ats_module('JobDetails').get_job_details(@job)
      ats_module('ApplicationFields').get_application_criteria(@job)
      ats_module('ApplicationFields').update_requirements(@job)
    else
      p "Unable to detect ATS system for URL: #{@url}"
      return nil
    end
  end
end
