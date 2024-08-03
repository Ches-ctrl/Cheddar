# frozen_string_literal: true

class LastApplicantAnswersFetcher < ApplicationTask
  def initialize(current_user)
    @current_user = current_user
    @user_detail = current_user.user_detail
    @job_applications = current_user.job_applications # .where(status: "completed")
  end

  def call
    return false unless processable

    process
  end

  private

  def processable
    @current_user && @user_detail
  end

  def process
    answers
  end

  ###

  def answers
    all_answers = (job_applications_answers + user_detail_answers).flatten.uniq
    last_uniq_answers(all_answers)
  end

  def job_applications_answers
    @job_applications.map do |job_application|
      job_application.additional_info.map { |key, value| { key => value, updated_at: job_application.updated_at } }
    end.flatten
  end

  def last_uniq_answers(answers)
    uniq_answers(sorted_answers(answers))
  end

  def sorted_answers(array_of_hash)
    array_of_hash.sort_by { |hash| hash[:updated_at] }.reverse
  end

  def uniq_answers(array_of_hash)
    array_of_hash.uniq { |hash| hash.keys.first }
  end

  def user_detail_answers
    @user_detail.info.map { |key, value| { key => value, updated_at: @user_detail.updated_at } }
  end
end
