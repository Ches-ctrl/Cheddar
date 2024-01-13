require 'cgi'
# require 'net/http'

class JobCreator
  SUPPORTED_ATS_SYSTEMS = [
    'greenhouse',
    'workable',
    'lever',
    'smartrecruiters',
    'ashby',
    'totaljobs',
    'simplyhired',
    'workday',
    # 'indeed',
    # 'freshteam',
    # 'phenom',
    # 'jobvite',
    # 'icims',
  ].freeze

  def initialize(job)
    @job = job
    @url = job.job_posting_url
  end

  def add_job_details
    # return unless @url.include?('greenhouse')
    return unless SUPPORTED_ATS_SYSTEMS.any? { |ats| @url.include?(ats) }

    ats_system = SUPPORTED_ATS_SYSTEMS.find { |ats| @url.include?(ats) }

    match = parse_greenhouse_url
    return unless match
    ats_identifier = match[1]
    job_posting_id = match[2]

    check_job_is_live

    if @job.live
      data = fetch_job_data(ats_identifier, job_posting_id)
      update_job_details(data)
    end

    puts "Updated job details - #{@job.job_title}"
    @job
  end

  def check_job_is_live
    uri = URI(@url)
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPRedirection)
      p "Job is not live"
      @job.job_title = 'Job is no longer live'
      @job.job_description = 'Job is no longer live'
      @job.live = false
    else
      p "Job is live"
      @job.live = true
    end
  end

  private

  # TODO: Convert job_posting_url to standard format

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
