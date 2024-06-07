# frozen_string_literal: true

class OpportunitiesQuery < ApplicationQuery
  def initialize(relation = Job.all)
    @relation = relation
  end

  def call
    @relation.eager_load(*associations)
    #  .order(desc_order)
  end

  private

  def associations
    %i[requirement company locations countries roles]
  end
end
