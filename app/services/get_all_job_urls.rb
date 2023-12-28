class GetAllJobUrls
  def initialize(company)
    @company = company
    @url = company.url_ats
    @ats_identifier = company.ats_identifier
  end

  def get_all_job_urls
    return unless @url.include?('greenhouse')
    data = fetch_company_jobs(@ats_identifier)
    job_urls = get_job_urls(data)
    total_live = total_live(data)

    @company.update(total_live: total_live)
    add_jobs_to_cheddar(job_urls)

    # TODO: Remove any existing URLs in database from job_urls before running method

    p "Total live jobs - #{total_live}"
    p "Total new jobs added - ..."

    p "Sourced all job urls for - #{@company.company_name}"
  end

  private

  def fetch_company_jobs(ats_identifier)
    company_api_url = "https://boards-api.greenhouse.io/v1/boards/#{ats_identifier}/jobs"
    uri = URI(company_api_url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    p data
  end

  def get_job_urls(data)
    job_urls = data['jobs'].map { |job| job['absolute_url'] }
  end

  def total_live(data)
    total_live = data['meta']['total']
  end

  def add_jobs_to_cheddar(job_urls)
    job_urls.each { |job_url| AddJobToCheddarJob.perform_later(job_url) } if job_urls.any?
  end
end
