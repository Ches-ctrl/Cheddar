class JobCreator
  include AtsRouter

  # TODO: Add req_work_eligibility to job model

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
      update_requirements(@job)
    else
      p "Unable to detect ATS system for URL: #{@url}"
      return nil
    end
  end

  # TODO: Handle job.date_created - have as the day scraped (this will work when cheddar is up and running)
  # TODO: Add default employment type of full-time
  # TODO: Add job industry as company's industry
  # TODO: Add no_of_questions and work_eligibility to job model
  # TODO: Set applicants_count and cheddar_applicants_count to 0 by default
  # TODO: Add create_account as false by default
  # TODO: Add this logic to the background job for scraping fields as well
  # TODO: Handle fields not found (will be more relevant when scraping fields each time)
  # TODO: Update defaults for req_cv and req_cover_letter, req_video_interview, req_online_assessment, req_first_round, req_second_round, req_assessment_centre

  def update_requirements(job)
    field_count = job.application_criteria.size
    p "Number of fields: #{field_count}"

    job.application_criteria.each do |field, criteria|
      case field
      when 'resume'
        job.req_cv = criteria['required']
        p "CV requirement: #{job.req_cv}"
      when 'cover_letter'
        job.req_cover_letter = criteria['required']
        p "Cover letter requirement: #{job.req_cover_letter}"
      # when 'work_eligibility'
      #   job.req_work_eligibility = criteria['required']
      #   p "Work eligibility requirement: #{job.req_work_eligibility}"
      end
    end
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
