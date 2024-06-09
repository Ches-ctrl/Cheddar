class OpportunityAutocompleteController < ApplicationController
  before_action :authenticate_user!, except: %i[index]

  def index
    query = params[:query]
    results = Job.search_job(query).limit(10) # Limit results
    render json: results.map { |opportunity| { label: opportunity.title, value: opportunity.id } } # Format data for Algolia
  end
end
