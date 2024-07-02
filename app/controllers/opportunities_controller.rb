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

  # Builds the facets based on the list of jobs and params
  def load_facets
    @facets, @sort = OpportunityFacetsBuilder.call(@opportunities, opportunity_params)
  end

  # Fetches a particular job based on a pre-defined scope and params
  def load_opportunity
    @opportunity = OpportunitiesFetcher.call(opportunity_scope, opportunity_params)
                                       .find(params[:id])
  end

  # Fetches relevant jobs based on a pre-defined scope and params
  def load_opportunities
    @opportunities = OpportunitiesFetcher.call(opportunity_scope, opportunity_params)
    @pagy, @records = pagy(@opportunities, items: 20)
  end

  def opportunity_params
    params.permit(:page, :posted, :query, :sort, { employment: [], location: [], role: [], seniority: [], ats: [] })
  end

  # policy_scope(Job)
  def opportunity_scope = Job.all
end
