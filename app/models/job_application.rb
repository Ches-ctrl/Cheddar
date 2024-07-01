# frozen_string_literal: true

class JobApplication < ApplicationRecord
  # == Attributes ===========================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Constants ============================================================
  # == Extensions ===========================================================
  serialize :additional_info, coder: HashSerializer
  # store_accessor :additional_info, ADDITIONAL_INFO_ATTRIBUTES
  # == Instance Methods =====================================================
  # == Relationships ========================================================
  belongs_to :application_process
  belongs_to :job
  # == Scopes ===============================================================
  default_scope { order id: :asc }
  # == Validations ==========================================================
  validates :status, presence: true

  # Define custom methods (optional)
  def submitted?
    status == "submitted"
  end
end

# class JobApplication < ApplicationRecord
#   belongs_to :user
#   belongs_to :job

#   has_many :application_responses, dependent: :destroy

#   validates :status, presence: true
#   validates :job_id, uniqueness: { scope: :user_id }

#   accepts_nested_attributes_for :application_responses

#   has_one_attached :screenshot

#   # TODO: Check what happens if the job application fails - user should be able to resubmit
# end
