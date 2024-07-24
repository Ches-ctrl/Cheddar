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
  has_one :application_question_set, through: :job
  has_one :applicant_tracking_system, through: :job
  #   has_one_attached :screenshot

  # == Scopes ===============================================================
  default_scope { order id: :asc }

  # == Validations ==========================================================
  validates :status, presence: true

  def api_payload
    # application_question_set.questions.map { |question| question.payload(self) }
    application_question_set.questions.map do |question|
      # byebug if question.selector == "phone"
      question.payload(self)
    end
  end

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
