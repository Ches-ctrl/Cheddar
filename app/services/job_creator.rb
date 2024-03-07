class JobCreator
  include AtsRouter

  # TODO: Change column order on jobs model once stable

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

    # TODO: Add additional logic for checking job is live when not a redirect e.g. 404 response
    if response.is_a?(Net::HTTPNotFound)
      p "Job link 404 error"
      @job.job_title = 'Job not found - 404'
      @job.job_description = 'The job page does not exist - 404'
      @job.live = false
    elsif response.is_a?(Net::HTTPRedirection)
      p "Job link redirect"
      @job.job_title = 'Job not found - Redirect'
      @job.job_description = 'The job page does not exist - Redirect'
      @job.live = false
    elsif response.is_a?(Net::HTTPSuccess)
      @job.live = true
    else
      p "unexpected response: #{response.inspect}"
    end
  end

  def find_or_create_job
    if ats_system_name
      ats_module('JobDetails').get_job_details(@job)
      ats_module('ApplicationFields').get_application_criteria(@job)
      # ats_module('ApplicationFields').update_requirements(@job)
      update_requirements(@job)
      p "job fields getting"
      GetFormFieldsJob.perform_later(@job.job_posting_url)
      JobStandardizer.new(@job).standardize
    else
      p "Unable to detect ATS system for URL: #{@url}"
      return nil
    end
  end

  # TODO: Search job description for salary information
  # TODO: Search job description for seniority (or match on job title)
  # TODO: Add other relevant job characteristics e.g. stock options, bonus, benefits, days leave etc.

  def update_requirements(job)
    # TODO: Add this logic to the background job for scraping fields as well
    job.no_of_questions = job.application_criteria.size

    job.application_criteria.each do |field, criteria|
      case field
      when 'resume'
        job.req_cv = criteria['required']
        p "CV requirement: #{job.req_cv}"
      when 'cover_letter'
        job.req_cover_letter = criteria['required']
        p "Cover letter requirement: #{job.req_cover_letter}"
      when 'work_eligibility'
        job.work_eligibility = criteria['required']
        p "Work eligibility requirement: #{job.work_eligibility}"
      end
    end
  end

  def categorise_by_yoe(job)
  end

  # TODO: Find a way to handle these fields (won't get detail from ATS system)
  # when 'video_interview'
  #   job.req_video_interview = criteria['required']
  # when 'online_assessment'
  #   job.req_online_assessment = criteria['required']
  # when 'first_round'
  #   job.req_first_round = criteria['required']
  # when 'second_round'
  #   job.req_second_round = criteria['required']
  # when 'assessment_centre'
  #   job.req_assessment_centre = criteria['required']
end
