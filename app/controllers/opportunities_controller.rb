class OpportunitiesController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!, except: %i[index]

  def index
    load_opportunities
  end

  private

  def load_opportunities
    filtered_jobs = JobFilter.new(params).filter_and_sort

    @jobs = filtered_jobs.eager_load(associated_tables)
                         .order(sort_order(params[:sort]))
                         .page(params[:page])

    @pagy, @records = pagy(@jobs, items: 20)
  end

  def associated_tables
    %i[requirement company locations countries]
  end

  def sort_order(sort_param)
    sort_options = {
      'title' => 'jobs.title ASC',
      'title_desc' => 'jobs.title DESC',
      'company' => 'companies.name ASC',
      'company_desc' => 'companies.name DESC',
      'created_at' => 'jobs.created_at DESC',
      'created_at_asc' => 'jobs.created_at ASC'
    }.freeze

    sort_options.fetch(sort_param, 'jobs.created_at DESC')
  end
end
