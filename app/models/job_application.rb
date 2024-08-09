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
  has_one_attached :photo
  has_one_attached :resume
  has_one :application_question_set, through: :job
  has_one :applicant_tracking_system, through: :job
  #   has_one_attached :screenshot

  # == Scopes ===============================================================
  default_scope { order id: :asc }
  scope :in_progress, -> { where(status: %i[initial completed]) }
  scope :submitted, -> { where(status: %i[submitted]) }

  # == Validations ==========================================================
  enum :status, { initial: "initial", completed: "completed", uncompleted: "uncompleted", submitted: "submitted", rejected: "rejected" },
       default: :initial, validate: true

  def attachment(question)
    return photo if question.photo?
    return cover_letter if question.cover_letter?

    resume
  end

  def payload
    apply_url = job.apply_url || job.posting_url
    user_fullname = application_process.user.user_detail.full_name
    fields = application_question_set.questions.map do |question|
      next unless question.type

      question.payload(self)
    end
    { user_fullname:, apply_url:, fields: }
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
