# frozen_string_literal: true

class SavedSearchesQuery < ApplicationQuery
  def initialize(relation = SavedSearch.all)
    @relation = relation
  end

  def call
    @relation = @relation.order(:created_at) # .eager_load(*associations)
  end

  private

  def associations
    # %i[requirement company locations countries roles applicant_tracking_system]
    #   .push({ locations: :country })
  end
end
