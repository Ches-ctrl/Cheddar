class Company < ApplicationRecord
  belongs_to :applicant_tracking_system, optional: true
  has_many :jobs, dependent: :destroy

  validates :company_name, presence: true, uniqueness: true

  before_save :set_website_url, :fetch_description
  # validates :company_website_url, uniqueness: true

  # include PgSearch::Model

  # multisearchable against: [:company_name]

  COMPANY_NAME_FILTER = [
    /\blimited\b/i,
    /\bltd\b/i,
    /\(.+\)/
  ]

  private

  def standardize_name
    name = company_name
    name.strip!
    self.company_name = name.split.reject { |word| COMPANY_NAME_FILTER.any? { |filter| word.match?(filter) } }.join(' ')
  end

  def set_website_url
    return if company_website_url.present?

    clearbit_company_info = CompanyDomainService.lookup_domain(company_name)
    self.company_website_url = clearbit_company_info['domain'] if clearbit_company_info && clearbit_company_info['domain'].present?
  end

  def fetch_description
    inferred_description, @name_keywords = CompanyDescriptionService.lookup_company(company_name, ats_identifier)

    self.description = inferred_description if description.blank?
  end

  def fetch_industry
    return unless industry == 'n/a'

    industry, subcategory = CompanyIndustryService.lookup_industry(company_name, @name_keywords)

    self.industry = industry
    self.industry_subcategory = subcategory
  end
end

# TODO: Clarify why we have company_name and company_website_url rather than name and website as column names
