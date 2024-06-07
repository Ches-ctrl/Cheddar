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
    opportunities = OpportunitiesQuery.call(@opportunities)
    apply_filters(opportunities)
  end

  def apply_filters(opportunities)
    filters = {
      date_posted: filter_by_when_posted(@params[:posted]),
      seniority: filter_by_seniority(@params[:seniority]),
      locations: filter_by_location(@params[:location]),
      roles: filter_by_role(@params[:role]),
      employment_type: filter_by_employment(@params[:employment])
    }.compact

    opportunities.where(filters)
  end

  def filter_by_when_posted(param)
    return unless param.present?

    number = Constants::DateConversion::CONVERT_TO_DAYS[param] || 99_999
    number.days.ago..Date.today
  end

  def filter_by_location(param)
    return unless param.present?

    locations = param.split.map { |location| location.gsub('_', ' ').split.map(&:capitalize).join(' ') unless location == 'remote' }
    { city: locations }
  end

  def filter_by_role(param)
    { name: param.split } if param.present?
  end

  def filter_by_seniority(param)
    return unless param.present?

    param.split.map { |seniority| seniority.split('-').map(&:capitalize).join('-') }
  end

  def filter_by_employment(param)
    param.split if param.present?
  end
end
