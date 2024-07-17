# frozen_string_literal: true

class SavedSearchesQuery < ApplicationQuery
  def initialize(relation = SavedSearch.all)
    @relation = relation
  end

  def call
    @relation = @relation.order(:created_at)
  end

  # private
end
