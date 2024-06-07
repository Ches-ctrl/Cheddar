# frozen_string_literal: true

class OpportunitiesFetcher < ApplicationTask
  def initialize(opportunities, params)
    @opportunities = opportunities
    @params = params.to_h
  end

  def call
    return false unless processable

    process
  end

  private

  def processable
    true
  end

  def process
    # simple_query || full_search_query
    plain_query
  end

  def plain_query
    OpportunitiesQuery.call(@opportunities)
  end

  # def plain_query
  #   filtered_jobs = JobFilter.new(@params, @opportunities).filter_and_sort

  #   @jobs = filtered_jobs.eager_load(associated_tables)
  #                        .order(sort_order(params[:sort]))
  #   #  .page(params[:page])
  # end

  # def associated_tables
  #   %i[requirement company locations countries]
  # end

  # def sort_order(sort_param)
  #   sort_options = {
  #     'title' => 'jobs.title ASC',
  #     'title_desc' => 'jobs.title DESC',
  #     'company' => 'companies.name ASC',
  #     'company_desc' => 'companies.name DESC',
  #     'created_at' => 'jobs.created_at DESC',
  #     'created_at_asc' => 'jobs.created_at ASC'
  #   }.freeze

  #   sort_options.fetch(sort_param, 'jobs.created_at DESC')
  # end
end
