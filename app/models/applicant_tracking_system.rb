class ApplicantTrackingSystem < ApplicationRecord
  include ValidUrl

  has_many :companies
  has_many :jobs, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  after_initialize :fetch_methods

  def fetch_methods
    module_name = name&.gsub(/\W/, '')&.capitalize

    modules = [
      "Ats::#{module_name}::ApplicationFields",
      "Ats::#{module_name}::CompanyDetails",
      "Ats::#{module_name}::FetchCompanyJobs",
      "Ats::#{module_name}::JobDetails",
      "Ats::#{module_name}::ParseUrl"
    ]

    modules.each do |module_name|
      extend Object.const_get(module_name) if Object.const_defined?(module_name)
    end
  end

  def find_or_create_job_by_id(company, ats_job_id)
    job = Job.find_or_create_by(ats_job_id:) do |new_job|
      new_job.company = company
      data = fetch_job_data(new_job)
      return if data.blank?

      update_job_details(new_job, data)
    end

    return job
  end

  def find_or_create_job_by_data(company, data)
    ats_job_id = fetch_id(data)
    job = Job.find_or_create_by(ats_job_id:) do |new_job|
      new_job.company = company
      new_job.applicant_tracking_system = self
      new_job.api_url = job_url_api(base_url_api, company.ats_identifier, ats_job_id)
      return if data.blank? # is this return necessary given that ats_job_id is fetched from data?

      update_job_details(new_job, data)
    end

    return job
  end

  private

  def fetch_job_data(job)
    job.api_url = job_url_api(base_url_api, job.company.ats_identifier, job.ats_job_id)
    response = get(job.api_url)
    return JSON.parse(response)
  end

  def fetch_additional_fields(job)
    get_application_criteria(job)
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

  def try_standard_formats(url, regex_formats)
    regex_formats.each do |regex|
      next unless (match = url.match(regex))

      ats_identifier, job_id = match.captures
      return [ats_identifier, job_id]
    end
    return nil
  end

  def check_for_careers_url_redirect(company)
    url = URI(company.url_ats_main)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true if url.scheme == 'https'

    request = Net::HTTP::Get.new(url.request_uri)

    max_retries = 2
    retries = 0
    begin
      response = http.request(request)
    rescue Errno::ECONNRESET, OpenSSL::SSL::SSLError => e
      retries += 1
      if retries <= max_retries
        sleep(2**retries) # Exponential backoff
        retry
      else
        puts "Check for careers redirect failed after #{max_retries} retries: #{e.message}"
        return false
      end
    end

    if response.is_a?(Net::HTTPRedirection)
      redirected_url = URI.parse(response['Location'])
      company.update(url_careers: redirected_url)
      company.update(company_website_url: redirected_url.host)
    else
      p "No redirect for #{company.url_ats_main}"
    end
  end

  def convert_from_iso8601(iso8601_string)
    return Time.iso8601(iso8601_string)
  end

  def convert_from_milliseconds(millisecond_string)
    Time.at(millisecond_string.to_i / 1000)
  end
end
