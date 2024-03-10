class GetAllJobUrls
  include Ats::Greenhouse::FetchCompanyJobs

  def initialize(company)
    @company = company
    @url = company.url_ats_api
    @ats_identifier = company.ats_identifier
  end

  def get_all_job_urls
    return unless @url.include?('greenhouse')

    data = fetch_company_jobs(@ats_identifier)
    job_urls = get_job_urls(data)
    total_live = total_live(data)

    @company.update(total_live:)

    # Remove any existing URLs in database from job_urls
    job_urls.reject! { |job_url| Job.exists?(job_posting_url: job_url) }

    p job_urls

    jobs_to_add = add_jobs_to_cheddar(job_urls, @company)

    p "Total live jobs - #{total_live}"
    p "Total new jobs to be updated with the background job - #{jobs_to_add}"

    p "Sourced all job urls for - #{@company.company_name}"
  end

  private

  def total_live(data)
    data['meta']['total']
  end

  def add_jobs_to_cheddar(job_urls, company)
    p "Adding jobs to cheddar"
    job_urls.each { |job_url| AddJobToCheddarJob.perform_later(job_url, company) } if job_urls.any?
    job_urls.length
  end
end
