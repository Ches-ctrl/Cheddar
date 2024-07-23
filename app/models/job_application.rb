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
  #   has_one_attached :screenshot

  # == Scopes ===============================================================
  default_scope { order id: :asc }
  scope :in_progress, -> { where(status: %w[initial completed]) }
  scope :submitted, -> { where(status: %i[submitted]) }

  # == Validations ==========================================================
  enum :status, { initial: "initial", completed: "completed", submitted: "submitted", rejected: "rejected" },
       default: :initial, validate: true

  def api_payload
    application_question_set.questions.map do |question|
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
