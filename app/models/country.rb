class Country < ApplicationRecord
  has_many :locations
  has_many :jobs_countries, dependent: :destroy
  has_many :jobs, through: :jobs_countries

  validates :name, presence: true, uniqueness: true
end
