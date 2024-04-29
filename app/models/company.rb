class Company < ApplicationRecord
  include Relevant

  belongs_to :applicant_tracking_system, optional: true
  has_many :jobs, dependent: :destroy

  validates :name, presence: true
  validates :ats_identifier, presence: true, uniqueness: true

  before_save :set_website_url, :fetch_description

  # include PgSearch::Model

  # multisearchable against: [:name]

  def create_all_relevant_jobs
    ats = applicant_tracking_system
    all_jobs = ats.fetch_company_jobs(ats_identifier)
    all_jobs.each do |job_data|
      if relevant?(ats, job_data)
        job_id = ats.fetch_id(job_data)
        ats.find_or_create_job(self, job_id)
      end
    end
  end

  private

  def set_website_url
    return if url_website.present?

    clearbit_company_info = CompanyDomainService.lookup_domain(name)
    self.url_website = clearbit_company_info['domain'] if clearbit_company_info && clearbit_company_info['domain'].present?
  end

  def fetch_description
    inferred_description, @name_keywords = CompanyDescriptionService.lookup_company(name, ats_identifier)

    self.description = inferred_description if description.blank?
  end

  def fetch_industry
    return unless industry == 'n/a'

    industry, subcategory = CompanyIndustryService.lookup_industry(name, @name_keywords)

    self.industry = industry
    self.sub_industry = subcategory
  end
end
