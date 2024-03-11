class Country < ApplicationRecord
  has_many :locations
  has_many :job_countries

  validates :name, presence: true, uniqueness: true
end
