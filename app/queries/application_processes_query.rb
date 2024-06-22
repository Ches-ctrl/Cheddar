# frozen_string_literal: true

class ApplicationProcessesQuery < ApplicationQuery
  def initialize(relation = ApplicationProcess.all)
    @relation = relation
  end

  def call
    @relation = @relation.eager_load(*associations)
  end

  private

  def associations
    %i[jobs].push({ jobs: :company })
  end
end
