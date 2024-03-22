class ApplicantTrackingSystem < ApplicationRecord
  has_many :companies
  has_many :jobs, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def application_fields
    module_name = "Ats::#{name}::ApplicationFields"
    Object.const_get(module_name) if Object.const_defined?(module_name)
  end

  def company_details
    module_name = "Ats::#{name}::CompanyDetails"
    Object.const_get(module_name) if Object.const_defined?(module_name)
  end

  def fetch_company_jobs(ats_identifier)
    module_name = "Ats::#{name}::FetchCompanyJobs"
    Object.const_get(module_name).call(ats_identifier) if Object.const_defined?(module_name)
  end

  def job_details
    module_name = "Ats::#{name}::JobDetails"
    Object.const_get(module_name) if Object.const_defined?(module_name)
  end

  def parse_url
    module_name = "Ats::#{name}::ParseUrl"
    Object.const_get(module_name) if Object.const_defined?(module_name)
  end

  def find_or_create_company(ats_id)
    module_name = "Ats::#{name}::CompanyDetails"
    m = Object.const_get(module_name) if Object.const_defined?(module_name)
    m.find_or_create(ats_id)
  end

  def find_or_create_job_by_id(company, job_id)
    module_name = "Ats::#{name}::JobDetails"
    m = Object.const_get(module_name) if Object.const_defined?(module_name)
    m.find_or_create_by_id(company, job_id)
  end
end
