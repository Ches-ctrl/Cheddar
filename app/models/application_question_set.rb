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
  def question_by_attribute(attribute)
    questions.find { |question| question.attribute.eql?(attribute) }
  end

  def questions
    form_structure.map do |section|
      section['questions'].map { |question| ApplicationQuestion.new(question.merge(section: section['title'])) }
    end.flatten
  end

  def no_of_qs
    form_structure.map { |section| section[:questions] }.flatten.count
  end
end
