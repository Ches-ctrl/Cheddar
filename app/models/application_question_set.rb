# frozen_string_literal: true

class ApplicationQuestionSet < ApplicationRecord
  # == Attributes ===========================================================
  # == Callbacks ============================================================
  # == Constants ============================================================
  # == Extensions ===========================================================
  # serialize :frequent_asked_info, coder: HashSerializer
  # store_accessor :attr1, :attr2, :attr3, :attr4, :attr5
  # == Relationships ========================================================
  belongs_to :job
  # == Scopes ===============================================================
  # == Validations ==========================================================
  # == Instance Methods =====================================================
  # == Class Methods ========================================================
  def questions
    # hh = []
    # hh << form_structure.map { |section| section }
    #                     .map { |criterion_hash| criterion_hash['questions'] }
    #                     .flatten
    #                     .map { |question| Question.new(question) }
    # hh.flatten
    form_structure.map { |section| section }
                  .map { |criterion_hash| criterion_hash['questions'] }
                  .flatten
                  .map { |question| ApplicationQuestion.new(question) }
                  .flatten
  end

  def no_of_qs
    form_structure.map { |section| section[:questions] }.flatten.count
  end
end
