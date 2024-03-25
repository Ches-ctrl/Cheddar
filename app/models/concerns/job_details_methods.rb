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
      return if data.blank?

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
end
