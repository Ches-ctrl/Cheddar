class CreateJobByUrl

  def initialize(url)
    @url = url
  end

  def call
    return puts "Job already exists!" if Job.find_by(job_posting_url: @url)

    ats, ats_identifier, job_id = JobUrl.new(@url).parse

    company = ats.find_or_create_company(ats_identifier)
    job = ats.find_or_create_job_by_id(company, job_id) if job_id

    return [ats, company, job]
  end
end
