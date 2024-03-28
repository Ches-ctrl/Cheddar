module JobDetailsMethods
  include ValidUrl

  def find_or_create_by_id(company, ats_job_id)
    job = Job.find_or_create_by(ats_job_id:) do |new_job|
      new_job.company = company
      data = fetch_job_data(new_job)
      return if data.blank?

      update_job_details(new_job, data)
    end

    return job
  end

  def find_or_create_by_data(company, data)
    ats_job_id = fetch_id(data)
    job = Job.find_or_create_by(ats_job_id:) do |new_job|
      new_job.company = company
      new_job.applicant_tracking_system = this_ats
      new_job.api_url = job_url_api(base_url_api, company.ats_identifier, ats_job_id)
      return if data.blank? # is this return necessary given that ats_job_id is fetched from data?

      update_job_details(new_job, data)
    end

    return job
  end

  def fetch_job_data(job)
    ats = this_ats
    job.api_url = job_url_api(ats.base_url_api, job.company.ats_identifier, job.ats_job_id)
    response = get(job.api_url)
    return JSON.parse(response)
  end

  def fetch_additional_fields(job)
    ats = this_ats
    ats.application_fields.get_application_criteria(job)
    update_requirements(job)
    p "job fields getting"
    GetFormFieldsJob.perform_later(job)
    JobStandardizer.new(job).standardize
  end

  def update_requirements(job)
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
end
