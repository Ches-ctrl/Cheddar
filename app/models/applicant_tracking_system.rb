class ApplicantTrackingSystem < ApplicationRecord
  has_many :companies
  has_many :jobs, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
