# frozen_string_literal: true

class ApplicationCriterion < ApplicationRecord
  self.table_name = 'application_criteria'
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
                  .map { |question| Question.new(question) }
                  .flatten
  end
end
