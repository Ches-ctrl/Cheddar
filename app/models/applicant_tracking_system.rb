class ApplicantTrackingSystem < ApplicationRecord
  include ValidUrl

  has_many :companies
  has_many :jobs, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  after_initialize :include_modules

  def include_modules
    return unless name

    module_name = name.gsub(/\W/, '').capitalize

    modules = [
      "Ats::#{module_name}::ParseUrl",
      "Ats::#{module_name}::CompanyDetails",
      "Ats::#{module_name}::FetchCompanyJobs",
      "Ats::#{module_name}::JobDetails",
      "Ats::#{module_name}::ApplicationFields",
    ]

    modules.each do |module_name|
      extend Object.const_get(module_name) if Object.const_defined?(module_name)
    end
  end

  # -----------------------
  # Find or Create Methods
  # -----------------------

  def find_or_create_job_by_id(company, ats_job_id)
    p "find_or_create_job_by_id: #{ats_job_id}"
    job = Job.find_or_create_by(ats_job_id:) do |new_job|
      new_job.company = company

      data = fetch_job_data(new_job)
      update_job_details(new_job, data)
      get_application_criteria(new_job)
      update_requirements(new_job)
    end

    return job
  end

  def find_or_create_job_by_data(company, data)
    p "find_or_create_job_by_data: #{data}"
    ats_job_id = fetch_id(data)

    job = Job.find_or_create_by(ats_job_id:) do |new_job|
      new_job.company = company
      new_job.applicant_tracking_system = self
      new_job.api_url = job_url_api(base_url_api, company.ats_identifier, ats_job_id)

      data = fetch_job_data(new_job)
      update_job_details(new_job, data)
      get_application_criteria(new_job)
      update_requirements(new_job)
    end

    return job
  end

  private

  # -----------------------
  # For processesing job_posting_url
  # -----------------------

  def try_standard_formats(url, regex_formats)
    regex_formats.each do |regex|
      next unless (match = url.match(regex))

      ats_identifier, job_id = match.captures
      return [ats_identifier, job_id]
    end
    return nil
  end

  # -----------------------
  # Get Job Data, Additional Fields and Update Requirements
  # -----------------------

  def fetch_job_data(job)
    job.api_url = job_url_api(base_url_api, job.company.ats_identifier, job.ats_job_id)
    response = get(job.api_url)
    return JSON.parse(response)
  end

  def update_requirements(job)
    job.no_of_questions = job.application_criteria.size

    job.application_criteria.each do |field, criteria|
      case field
      when 'resume'
        job.req_cv = criteria['required']
      when 'cover_letter'
        job.req_cover_letter = criteria['required']
      when 'work_eligibility'
        job.work_eligibility = criteria['required']
      end
    end
  end

  # -----------------------
  # Time Conversions
  # -----------------------

  def convert_from_iso8601(iso8601_string)
    return Time.iso8601(iso8601_string)
  end

  def convert_from_milliseconds(millisecond_string)
    Time.at(millisecond_string.to_i / 1000)
  end
end
