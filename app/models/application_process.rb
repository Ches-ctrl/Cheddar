# frozen_string_literal: true

class ApplicationProcess < ApplicationRecord
  # == Attributes ===========================================================
  # == Callbacks ============================================================
  # == Constants ============================================================
  # == Extensions ===========================================================
  # serialize :frequent_asked_info, coder: HashSerializer
  # store_accessor :attr1, :attr2, :attr3, :attr4, :attr5

  # == Relationships ========================================================
  belongs_to :user
  has_many :job_applications, dependent: :destroy
  has_many :jobs, through: :job_applications
  # == Scopes ===============================================================
  # == Validations ==========================================================
  validates :status, presence: true

  # == Instance Methods =====================================================
  def find_application_for_job(job)
    job_applications.find_by(job:)
  end

  def submitted?
    submitted_at.present?
  end
  # == Class Methods ========================================================
end
