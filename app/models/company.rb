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
    jobs_created = 0
    ats = applicant_tracking_system
    all_jobs = ats.fetch_company_jobs(ats_identifier)
    all_jobs.each do |job_data|
      details = ats.fetch_title_and_location(job_data)
      p details
      next unless relevant?(*details)

      # create jobs with data from ATS company endpoint unless individual job endpoint exists:
      if ats.individual_job_endpoint_exists?
        job_id = ats.fetch_id(job_data)
        job = ats.find_or_create_job(self, job_id)
      else
        job = ats.find_or_create_job_by_data(self, job_data)
      end
      jobs_created += 1 if job&.persisted?
    end
    puts "Created #{jobs_created} new jobs with #{name}."
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
