# frozen_string_literal: true

class JobApplicationStatusFetcher < ApplicationTask
  def initialize(job_application)
    @job_application = job_application
    @questions = job_application.application_question_set.questions
  end

  def call
    return false unless processable

    process
  end

  private

  def processable
    @job_application && @questions
  end

  def process
    current_status
  end

  ###

  def current_status
    required_attributes = required_attributes(@questions)
    non_empty_or_null_attributes = non_empty_or_null_attributes(@job_application.additional_info)
    (required_attributes - non_empty_or_null_attributes).empty? ? "completed" : "uncompleted"
  end

  def non_empty_or_null_attributes(hash)
    keys = hash.select { |_key, value| !value.nil? && !value.empty? }.keys
    keys << 'resume' if @job_application.resume.attached?
    keys << 'cover_letter' if @job_application.cover_letter.attached?
    keys
  end

  def required_attributes(questions)
    questions.select(&:required).map(&:attribute)
  end
end
