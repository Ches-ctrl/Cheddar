class Company < ApplicationRecord
  belongs_to :applicant_tracking_system, optional: true
  has_many :jobs, dependent: :destroy

  validates :company_name, presence: true, uniqueness: true

  before_save :set_website_url
  # validates :company_website_url, uniqueness: true

  # include PgSearch::Model

  # multisearchable against: [:company_name]

  private

  def set_website_url
    return if company_website_url.present?

    clearbit_company_info = CompanyDomainService.lookup_domain(company_name)
    self.company_website_url = clearbit_company_info['domain'] if clearbit_company_info && clearbit_company_info['domain'].present?
  end
end

# TODO: Clarify why we have company_name and company_website_url rather than name and website as column names
