class Company < ApplicationRecord
  has_many :jobs, dependent: :destroy

  validates :company_name, presence: true, uniqueness: true
  # validates :company_website_url, uniqueness: true

  # include PgSearch::Model

  # multisearchable against: [:company_name]
end
