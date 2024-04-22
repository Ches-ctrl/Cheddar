class Company < ApplicationRecord
  belongs_to :applicant_tracking_system, optional: true
  has_many :jobs, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  # validates :url_website, uniqueness: true

  before_save :set_website_url, :fetch_description

  # include PgSearch::Model

  # multisearchable against: [:name]

  COMPANY_NAME_FILTER = [
    /\blimited\b/i,
    /\bltd\b/i,
    /\(.+\)/
  ]

  private

  # TODO: Fix this as may break with new naming setup @Dan

  def standardize_name
    name = name
    name.strip!
    self.name = name.split.reject { |word| COMPANY_NAME_FILTER.any? { |filter| word.match?(filter) } }.join(' ')
  end

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
    self.industry_subcategory = subcategory
  end
end
