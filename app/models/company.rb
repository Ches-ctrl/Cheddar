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
    jobs_found_or_created = []
    ats = applicant_tracking_system
    all_jobs = ats.fetch_company_jobs(ats_identifier)
    raise NoDataReturnedError, "The API returned no jobs data for #{name}" unless all_jobs

    all_jobs.each do |job_data|
      details = ats.fetch_title_and_location(job_data)
      next unless relevant?(*details)

      # create jobs with data from ATS company endpoint unless individual job endpoint exists:
      if ats.individual_job_endpoint_exists?
        job_id = ats.fetch_id(job_data)
        job = ats.find_or_create_job(self, job_id)
      else
        job = ats.find_or_create_job_by_data(self, job_data)
      end
      jobs_found_or_created << job if job&.persisted?
    end
    puts "Found or created #{jobs_found_or_created.size} new jobs with #{name}."
    jobs_found_or_created
  end

  private

  # TODO: Have identified these as the primary drivers of slow test speed due to API calls. Need to decide on next steps.
  # TODO: This is a very hacky temporary solution to speed up tests. Need to fix this

  def set_website_url
    return if url_website.present?

    if Rails.env.production?
      clearbit_company_info = CompanyDomainService.lookup_domain(name)
      self.url_website = clearbit_company_info['domain'] if clearbit_company_info && clearbit_company_info['domain'].present?
    else
      self.url_website = "https://www.example.com"
    end
  end

  def fetch_description
    if Rails.env.production?
      inferred_description, @name_keywords = CompanyDescriptionService.lookup_company(name, ats_identifier)
      self.description = inferred_description if description.blank?
    else
      self.description = "A financial services company."
    end
  end

  def fetch_industry
    return unless industry == 'n/a'

    if Rails.env.production?
      industry, subcategory = CompanyIndustryService.lookup_industry(name, @name_keywords)
      self.industry = industry
      self.sub_industry = subcategory
    else
      self.industry = "Finance"
      self.sub_industry = "Banking"
    end
  end
end
