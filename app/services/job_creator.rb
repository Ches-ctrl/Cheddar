require 'cgi'

class JobCreator
  def initialize(job)
    @job = job
    @url = job.job_posting_url
  end

  def add_job_details
    return unless @url.include?('greenhouse')

    match = parse_greenhouse_url
    return unless match
    ats_identifier = match[1]
    job_posting_id = match[2]

    data = fetch_job_data(ats_identifier, job_posting_id)
    update_job_details(data)

    puts "Updated job details - #{@job.job_title}"
    @job
  end

  private

  def parse_greenhouse_url
    @url.match(%r{https://boards\.greenhouse\.io/([^/]+)/jobs/(\d+)})
  end

  def fetch_job_data(ats_identifier, job_posting_id)
    job_api_url = "https://boards-api.greenhouse.io/v1/boards/#{ats_identifier}/jobs/#{job_posting_id}"
    uri = URI(job_api_url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
  end

  def update_job_details(data)
    # Note job description is HTML here
    # TODO: Test Decoder
    decoded_description = CGI.unescapeHTML(data['content'])

    @job.update(
      job_title: data['title'],
      job_description: decoded_description,
    )
    @job.update(location: data['location']['name']) if data['location'].present?
    # @job.update(department: data['departments'][0]['name']) if data['departments'].present?
    # @job.update(office: data['offices'][0]['name']) if data['offices'].present?
  end
end
