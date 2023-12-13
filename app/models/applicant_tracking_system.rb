class ApplicantTrackingSystem < ApplicationRecord
  has_many :jobs, dependent: :destroy
end
