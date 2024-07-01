class OpportunitiesController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!, except: %i[index show]

  def index
    load_opportunities
    load_facets
  end

  def show
    load_opportunity
  end

  private

  def load_facets
    @facets = OpportunityFacetsBuilder.call(@opportunities, opportunity_params)
  end

  def load_opportunity
    @opportunity = OpportunitiesFetcher.call(opportunity_scope, opportunity_params)
                                       .find(params[:id])
  end

  def load_opportunities
    @opportunities = OpportunitiesFetcher.call(opportunity_scope, opportunity_params)
    @pagy, @records = pagy(@opportunities, items: 20)
  end

  def opportunity_params
    params.permit(:id, :page, :posted, :query, :sort, { employment: [], location: [], role: [], seniority: [] })
  end

  # policy_scope(Job)
  def opportunity_scope = Job.all
end
