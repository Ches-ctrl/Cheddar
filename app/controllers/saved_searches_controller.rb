class SavedSearchesController < ApplicationController
  def create
    build_saved_search
    persist_saved_search
  end

  private

  def build_saved_search
    @saved_search = current_user.saved_searches.new(params: saved_search_params)
  end

  def generate_csv
    ExportJobCsvGenerator.call(@saved_search)
  end

  def persist_saved_search
    if @saved_search.save && generate_csv
      success_saved_search_redirect_to_referrer
    else
      error_redirect_to_referrer
    end
  end

  def success_saved_search_redirect_to_referrer
    redirect_to request.referrer, notice: 'Search successfully saved!'
  end

  def error_redirect_to_referrer
    redirect_to request.referrer, alert: 'Something went wrong, please try again'
  end

  def saved_search_params
    helpers.permitted_search_params
  end
end
