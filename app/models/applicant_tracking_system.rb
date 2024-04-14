class ApplicantTrackingSystem < ApplicationRecord
  include ValidUrl
  include AtsSystemParser
  include AtsRouter

  has_many :companies
  has_many :jobs, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  after_initialize :include_modules

  # -----------------------
  # Modules
  # -----------------------

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
  # ATS Router
  # -----------------------

  def self.determine_ats(url)
    name = ATS_SYSTEM_PARSER.find { |regex, ats_name| break ats_name if url.match?(regex) }
    return ApplicantTrackingSystem.find_by(name:)
  end

  # -----------------------
  # Parse URL
  # -----------------------

  def self.parse_url(ats, url)
    ats.parse_url(url)
  end

  # def parse(ats, list = nil)
  #   if SUPPORTED_ATS_SYSTEMS.include?(ats.name)
  #     ats_identifier, job_id = list ? ats.parse_url(url, list[ats.name]) : ats.parse_url(url)
  #     [ats, ats_identifier, job_id]
  #   elsif ats
  #     ats
  #   else
  #     url
  #   end
  # end

  # -----------------------
  # CompanyCreator
  # -----------------------

  def self.find_or_create_company(ats, ats_identifier)
    ats.find_or_create_company(ats_identifier)
  end

  # -----------------------
  # Company Details
  # -----------------------

  # TODO: Fix the variables being passed back and forth here once everything is working

  def self.get_company_details(url, ats, ats_identifier)
    company = ats.get_company_details(url, ats, ats_identifier) # rubocop:disable Lint/UselessAssignment
  end

  # -----------------------
  # Fetch Company Jobs
  # -----------------------

  def self.get_company_jobs(ats, url)
    ats.get_company_jobs(url)
  end

  # -----------------------
  # JobCreator
  # -----------------------

  # def self.find_or_create_job_by_data(company, data)
  #   # Add logic here that if it is from a certain ATS system then it routes differently so we don't re-request the API a million times

  #   p "find_or_create_job_by_data - #{data}"
  #   ats_job_id = fetch_id(data)
  #   find_or_create_job_by_id(company, ats_job_id)
  # end

  def self.find_or_create_job_by_id(company, ats_job_id)
    p "find_or_create_job_by_id - #{ats_job_id}"

    job = Job.find_or_create_by(ats_job_id:) do |new_job|
      new_job.company = company

      data = fetch_job_data(new_job)
      update_job_details(new_job, data)
      get_application_criteria(new_job)
      update_requirements(new_job)
    end
    return job
  end

  # -----------------------
  # GetAllJobUrls
  # -----------------------

  # -----------------------
  # Job Details
  # -----------------------

  def self.create_job(url, ats, company, ats_job_id)
    # Does this need to be find_or_create_by?
    job = Job.create(
      job_title: "Placeholder Job Title - #{ats.name} - #{ats_job_id}",
      job_posting_url: url,
      company_id: company.id,
      applicant_tracking_system_id: ats.id,
      ats_job_id:
    )
    job.save
    p job

    data = ats.fetch_job_data(ats, job)
    ats.update_job_details(job, data)
    # ats.create_application_criteria_hash(job)
    job
  end

  # -----------------------
  # Application Fields
  # -----------------------

  def self.get_application_criteria(ats, url)
    ats.get_application_criteria(url)
  end

  private

  # -----------------------
  # Parse URL
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
  # Job Details
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
