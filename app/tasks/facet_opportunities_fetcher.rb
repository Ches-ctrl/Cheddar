# frozen_string_literal: true

class FacetOpportunitiesFetcher < OpportunitiesFetcher
  private

  def apply_filters(opportunities)
    opportunities.where(filters)
  end
end
