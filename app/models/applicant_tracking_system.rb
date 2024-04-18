class ApplicantTrackingSystem < ApplicationRecord
  include CheckUrlIsValid
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
      "Ats::#{module_name}::ApplicationFields"
    ]

    modules.each do |module_name|
      extend Object.const_get(module_name) if Object.const_defined?(module_name)
    end
  end

  def refer_to_module(method, method_name)
    return method if method

    puts "Write a #{method_name} method for #{name}!"
    return
  end

  # -----------------------
  # ATS Router
  # -----------------------

  def self.determine_ats(url)
    name = ATS_SYSTEM_PARSER.find { |regex, ats_name| break ats_name if url.match?(regex) }
    return ApplicantTrackingSystem.find_by(name:)
  end

  def self.check_ats
    # TODO: Check if company is still hosted by an ATS or has moved provider (this actually may want to sit in CheckUrlIsValid)
  end

  # -----------------------
  # Parse URL
  # -----------------------

  def parse_url(url)
    refer_to_module(defined?(super) ? super : nil, __method__)
  end

  # -----------------------
  # CompanyCreator
  # -----------------------

  def find_or_create_company(ats_identifier, data = nil)
    company = Company.find_or_initialize_by(ats_identifier:) do |new_company|
      company_data = company_details(ats_identifier)

      new_company.applicant_tracking_system = self
      new_company.assign_attributes(company_data)
    end

    if data
      supplementary_data = company_details_from_data(data)
      company.assign_attributes(supplementary_data)
    end

    company.total_live = fetch_total_live(ats_identifier)
    p "Total live - #{company.total_live}"

    p "Company created - #{company.company_name}" if company.new_record? && company.save

    return company
  end

  def find_or_create_company_by_data(data)
    ats_identifier = fetch_company_id(data)
    find_or_create_company(ats_identifier, data)
  end

  # -----------------------
  # Company Details
  # -----------------------

  private

  def company_details(ats_identifier, data = nil)
    refer_to_module(defined?(super) ? super : nil, __method__)
  end

  def company_details_from_data(data)
    refer_to_module(defined?(super) ? super : nil, __method__)
  end

  def fetch_company_id(data)
    refer_to_module(defined?(super) ? super : nil, __method__)
  end

  def fetch_company_name(ats_identifier)
    url = "https://autocomplete.clearbit.com/v1/companies/suggest?query=#{ats_identifier}"
    response = get(url)
    data = JSON.parse(response)
    return data.dig(0, 'name') unless data.blank?
  end

  def replace_ats_identifier(ats_identifier)
    api_url = base_url_api
    main_url = base_url_main

    api_url.gsub!("XXX", ats_identifier)
    main_url.gsub!("XXX", ats_identifier)
    [api_url, main_url]
  end

  def fetch_total_live(ats_identifier)
    refer_to_module(defined?(super) ? super : nil, __method__)
  end

  public

  # -----------------------
  # JobCreator
  # -----------------------

  # TODO: rename to find_or_create_job
  def find_or_create_job(company, ats_job_id, data = nil)

    job = Job.find_or_create_by(ats_job_id:) do |new_job|
      new_job.company = company
      new_job.applicant_tracking_system = self
      new_job.api_url = job_url_api(base_url_api, company.ats_identifier, ats_job_id)
      data ||= fetch_job_data(new_job)
      return if data.blank?

      job_details(new_job, data)
      fetch_additional_fields(new_job)
    end

    puts "Created new job - #{job.job_title} with #{company.company_name}"

    return job
  end

  def find_or_create_job_by_data(company, data)
    ats_job_id = fetch_id(data)
    find_or_create_job(company, ats_job_id, data)
  end

  private

  def job_details(new_job, data)
    refer_to_module(defined?(super) ? super : nil, __method__)
  end

  def job_url_api(base_url_api, ats_identifier, ats_job_id)
    refer_to_module(defined?(super) ? super : nil, __method__)
  end

  def fetch_job_data(job)
    response = get(job.api_url)
    return JSON.parse(response)
  end

  def fetch_additional_fields(job)
    get_application_criteria(job)
    p "job fields getting"
    job.save
    GetFormFieldsJob.perform_later(job) # TODO: create separate module methods for this
  end

  public

  # TODO: ApplicantTrackingSystem should handle all public instance methods contained in
  # ats-specific modules as in the example below:
  def parse_url(url)
    return super if defined?(super)

    p "Write a parse_url method for #{name}!"
    return
  end

  # -----------------------
  # Parse URL
  # -----------------------

  def self.parse_url(ats, url)
    ats.parse_url(url)
  end

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

  # TODO: Fix this so that it doesn't re-request the API multiple times according to Dan improvements e.g. PinpointHQ

  def self.find_or_create_job_by_data(company, data)
    p "find_or_create_job_by_data - #{data}"

    ats_job_id = fetch_id(data)
    find_or_create_job_by_id(company, ats_job_id)
  end

  def self.find_or_create_job_by_id(url, ats, company, ats_job_id)
    p "Finding or creating job by ID - #{ats_job_id}"

    job = Job.find_or_create_by(ats_job_id:) do |job|
      job.job_title = "Placeholder - #{ats.name} - #{ats_job_id}"
      job.job_posting_url = url
      job.company = company
      job.applicant_tracking_system = ats
      job.ats_job_id = ats_job_id
    end
    p "Job created - #{job.job_title}"

    # TODO: Refactor fetch_job_data as lots of repeated code in modules that can be reconciled
    # TODO: May be able to remove all the separate modules and just have one module for each ATS
    data = ats.fetch_job_data(job, ats)
    ats.job_details(job, data)
    # ats.create_application_criteria_hash(job) # TODO: add methods so that this can be called

    job
  end

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

  # def fetch_job_data(job)
  #   job.api_url = job_url_api(base_url_api, job.company.ats_identifier, job.ats_job_id)
  #   response = get(job.api_url)
  #   return JSON.parse(response)
  # end

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
