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
  has_one_attached :cover_letter
  has_one_attached :resume
  # == Scopes ===============================================================
  default_scope { order id: :asc }
  # == Validations ==========================================================
  validates :status, presence: true

  # Define custom methods (optional)
  def submitted?
    status.eql?("submitted")
  end

  def completed?
    status.eql?("completed")
  end

  def uncompleted?
    status.eql?("uncompleted")
  end

  def unstarted?
    status.eql?("new")
  end
end
