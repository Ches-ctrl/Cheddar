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
    form_structure.map do |_section, section_data|
      next unless section_data.is_a?(Hash)

      section_data['questions'].map { |question| ApplicationQuestion.new(question.merge(section: section_data['title'])) }
    end.compact.flatten
  end

  def no_of_qs
    form_structure.select { |section| section['questions'] }.flatten.count
  end
end
