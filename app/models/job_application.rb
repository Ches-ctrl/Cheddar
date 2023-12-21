class JobApplication < ApplicationRecord

  belongs_to :user
  belongs_to :job

  has_many :application_responses, dependent: :destroy

  validates :status, presence: true
  validates :job_id, uniqueness: { scope: :user_id }

  accepts_nested_attributes_for :application_responses

  has_one_attached :screenshot

  # TODO: Check what happens if the job application fails - user should be able to resubmit
end
