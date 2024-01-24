class Company < ApplicationRecord
  belongs_to :applicant_tracking_system, optional: true
  has_many :jobs, dependent: :destroy

  validates :company_name, presence: true, uniqueness: true
  # validates :company_website_url, uniqueness: true

  # include PgSearch::Model

  # multisearchable against: [:company_name]
end

# TODO: Clarify why we have company_name and company_website_url rather than name and website as column names
