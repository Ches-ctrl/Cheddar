# frozen_string_literal: true

class ApplicationProcess < ApplicationRecord
  # == Attributes ===========================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Constants ============================================================
  # == Extensions ===========================================================
  serialize :frequent_asked_info, coder: HashSerializer
  # store_accessor :attr1, :attr2, :attr3, :attr4, :attr5
  # == Instance Methods =====================================================
  # == Relationships ========================================================
  belongs_to :user
  has_many :job_applications, dependent: :destroy
  # == Scopes ===============================================================
  # == Validations ==========================================================
  validates :status, presence: true
  validates :frequent_asked_info, presence: true

  # Define custom methods (optional)
  def self.by_status(status)
    where(status:)
  end

  def submitted?
    submitted_at.present?
  end
end
