# frozen_string_literal: true

class ApplicationProcessesQuery < ApplicationQuery
  def initialize(relation = ApplicationProcess.all)
    @relation = relation
  end

  def call
    @relation = @relation.eager_load(*associations)
                         .order('job_applications.created_at': :asc)
  end

  private

  def associations
    %i[job_applications]
      .push({ job_applications: { job: %i[company application_question_set] } })
  end
end
