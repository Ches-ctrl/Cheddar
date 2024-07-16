class SavedSearchesController < ApplicationController
  include Pagy::Backend

  def index
    load_saved_searches
  end

  def create
    build_saved_search
    persist_saved_search
  end

  def update
    load_saved_search
    assign_job_search_params
    persist_saved_search
  end

  def destroy
    load_saved_search
    destroy_saved_search
  end

  private

  def assign_job_search_params
    @saved_search.assign_attributes(saved_search_params)
  end

  def build_saved_search
    @saved_search = current_user.saved_searches.new(params: saved_search_params)
  end

  def destroy_saved_search
    if @saved_search.destroy
      success_redirect_to_referrer('Search successfully unsaved!')
    else
      error_redirect_to_referrer('Something went wrong, please try again')
    end
  end

  def generate_csv
    return true unless current_user.admin?

    ExportJobCsvGenerator.call(@saved_search)
  end

  def load_saved_search
    @saved_search = current_user.saved_searches.find_by(id: saved_search_params[:id])
  end

  def load_saved_searches
    @saved_searches = SavedSearchesQuery.call(saved_searches_scope)
    @pagy, @records = pagy(@saved_searches, items: 20)
  end

  def persist_saved_search
    if @saved_search.save && generate_csv && update_saved_search_stats
      success_redirect_to_referrer('Search successfully saved!')
    else
      error_redirect_to_referrer('Something went wrong, please try again')
    end
  end

  def saved_searches_scope
    current_user.saved_searches
  end

  def saved_search_params
    helpers.permitted_search_params.merge(params.permit(:id, :optin))
  end

  def update_saved_search_stats
    SavedSearchStatsUpdator.call(@saved_search)
  end
end
