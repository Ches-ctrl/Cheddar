class Company < ApplicationRecord
  # == Constants ============================================================
  include Relevant

  # == Attributes ===========================================================

  # == Extensions ===========================================================

  # == Relationships ========================================================
  belongs_to :applicant_tracking_system, optional: true
  has_many :jobs, dependent: :destroy

  # == Validations ==========================================================
  validates :name, presence: true
  validates :ats_identifier, presence: true, uniqueness: true

  # == Scopes ===============================================================
  # include PgSearch::Model

  # multisearchable against: [:name]

  # == Callbacks ============================================================

  # == Class Methods ========================================================

  # == Instance Methods =====================================================

  def short_description
    return if industry == 'n/a'

    "#{industry} / #{sub_industry}"
  end

  def url_present?(url_type)
    send(url_type).present?
  end

  # TODO: Have identified these as the primary drivers of slow test speed due to API calls. Need to decide on next steps.
  # TODO: This is a very hacky temporary solution to speed up tests. Need to fix this
  # TODO: Remove these as depenedencies - we will find another way to do this

  def set_website_url
    return if url_website.present?

    if Rails.env.production?
      clearbit_company_info = Categorizer::CompanyDomainService.lookup_domain(name)
      self.url_website = clearbit_company_info['domain'] if clearbit_company_info && clearbit_company_info['domain'].present?
    else
      self.url_website = "https://www.example.com"
    end
  end

  # def fetch_industry
  #   return unless industry == 'n/a'

  #   if Rails.env.production?
  #     industry, subcategory = Categorizer::CompanyIndustryService.lookup_industry(name, @name_keywords)
  #     self.industry = industry
  #     self.sub_industry = subcategory
  #   else
  #     self.industry = "Finance"
  #     self.sub_industry = "Banking"
  #   end
  # end
end
