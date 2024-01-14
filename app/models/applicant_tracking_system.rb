class ApplicantTrackingSystem < ApplicationRecord
  has_many :jobs, dependent: :destroy
  has_many :ats_formats, dependent: :destroy
  has_one :company

  validates :name, presence: true, uniqueness: true
end
