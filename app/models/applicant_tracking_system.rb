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

  def fetch_embedded_job_id(url)
    refer_to_module(defined?(super) ? super : nil, __method__)
  end

  private

  def try_standard_formats(url, regex_formats)
    regex_formats.each do |regex|
      next unless (match = url.match(regex))

      ats_identifier, job_id = match.captures
      return [ats_identifier, job_id]
    end
    return nil
  end

  public

  # -----------------------
  # CompanyCreator
  # -----------------------

  def find_or_create_company(ats_identifier, data = nil)
    return unless ats_identifier

    company = Company.find_or_initialize_by(ats_identifier:) do |new_company|
      company_data = company_details(ats_identifier)

      new_company.applicant_tracking_system = self
      new_company.assign_attributes(company_data)
    end

    if data
      supplementary_data = company_details_from_data(data)
      company.assign_attributes(supplementary_data)
    end

    p "Company created - #{company.name}" if company.new_record? && company.save

    return company
  end

  def find_or_create_company_by_data(data)
    ats_identifier = fetch_company_id(data)
    find_or_create_company(ats_identifier, data)
  end

  # -----------------------
  # Company Details
  # -----------------------

  def company_details(ats_identifier, data = nil)
    refer_to_module(defined?(super) ? super : nil, __method__)
  end

  private

  def company_details_from_data(data)
    refer_to_module(defined?(super) ? super : nil, __method__)
  end

  def fetch_company_id(data)
    refer_to_module(defined?(super) ? super : nil, __method__)
  end

  def fetch_company_name(ats_identifier)
    url = "https://autocomplete.clearbit.com/v1/companies/suggest?query=#{ats_identifier}"
    data = get_json_data(url)
    return data.dig(0, 'name') unless data.blank?
  end

  def fetch_total_live(ats_identifier)
    fetch_company_jobs(ats_identifier)&.count
  end

  def replace_ats_identifier(ats_identifier)
    api_url = url_api.gsub("XXX", ats_identifier)
    main_url = url_base.gsub("XXX", ats_identifier)

    [api_url, main_url]
  end

  public

  # -----------------------
  # JobCreator
  # -----------------------

  def find_or_create_job(company, ats_job_id, data = nil)
    return unless company&.persisted?

    job = Job.find_or_create_by(ats_job_id:) do |new_job|
      new_job.company = company
      new_job.applicant_tracking_system = self
      new_job.api_url = job_url_api(url_api, company.ats_identifier, ats_job_id)
      data ||= fetch_job_data(new_job)
      return if data.blank? || data['error'].present? || data.values.include?(404)

      job_details(new_job, data)
      fetch_additional_fields(new_job, data)
      puts "Created new job - #{new_job.title} with #{company.name}"
    end

    return job
  end

  def find_or_create_job_by_data(company, data)
    ats_job_id = fetch_id(data)
    find_or_create_job(company, ats_job_id, data)
  end

  def individual_job_endpoint_exists?
    # This checks whether job_data is fetched from a job-specific endpoint.
    # Return false with Lever because its job-specific endpoint gives no additional data on top of
    # what the company endpoint gives.
    return false if name == 'Lever'

    parameters = method(:job_url_api).parameters
    parameters.any? { |param| param[1] == :job_id }
  end

  def fetch_company_jobs(ats_identifier)
    refer_to_module(defined?(super) ? super : nil, __method__)
  end

  def fetch_title_and_location(data)
    refer_to_module(defined?(super) ? super : nil, __method__)
  end

  private

  def job_details(new_job, data)
    refer_to_module(defined?(super) ? super : nil, __method__)
  end

  def job_url_api(url_api, ats_identifier, ats_job_id)
    refer_to_module(defined?(super) ? super : nil, __method__)
  end

  def fetch_job_data(job)
    get_json_data(job.api_url)
  end

  def fetch_additional_fields(job, data)
    get_application_criteria(job, data)
    p "job fields getting"
    job.save! # must save before passing to Sidekiq job
    GetFormFieldsJob.perform_later(job) # TODO: create separate module methods for this
  end

  # -----------------------
  # Time Conversions
  # -----------------------

  def convert_from_iso8601(iso8601_string)
    return Time.iso8601(iso8601_string) if iso8601_string
  end

  def convert_from_milliseconds(millisecond_string)
    Time.at(millisecond_string.to_i / 1000) if millisecond_string
  end
end
