class ApplicantTrackingSystem < ApplicationRecord
  has_many :companies
  has_many :jobs, dependent: :destroy
  has_many :ats_formats, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
