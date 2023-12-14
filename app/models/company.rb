class Company < ApplicationRecord
  has_many :jobs, dependent: :destroy

  validates :company_name, presence: true
  validates :company_name, uniqueness: true

  # include PgSearch::Model

  # multisearchable against: [:company_name]
end
