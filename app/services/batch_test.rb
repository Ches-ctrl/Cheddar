# frozen_string_literal: true

require './app/tasks/application_task'

class BatchTest < ApplicationTask
  def initialize(ats_list)
    @ats_list = ats_list
  end

  def call
    return false unless processable

    process
  end

  private

  def processable
    @ats_list.present?
  end

  def process
    p @ats_list
  end
end
