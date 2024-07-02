# frozen_string_literal: true

class OpportunitiesFetcher < ApplicationTask
  def initialize(opportunities, params)
    @opportunities = opportunities
    @params = params
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
    opportunities = OpportunitiesQuery.call(wanted_opportunities)
    apply_filters(opportunities)
  end

  def apply_filters(opportunities)
    opportunities.where(filters)
                 .order(sort)
  end

  def filter_by_ats(param)
    { name: param } if param.present?
  end

  def filter_by_when_posted(param)
    return unless param.present?

    number = Constants::DateConversion::CONVERT_TO_DAYS[param] || 99_999
    number.days.ago..Date.today
  end

  def filter_by_location(param)
    return unless param.present?

    locations = param.map { |location| location.gsub('_', ' ').split.map(&:capitalize).join(' ') unless location == 'remote' }
    { city: locations }
  end

  def filter_by_role(param)
    { name: param } if param.present?
  end

  def filter_by_seniority(param)
    return unless param.present?

    param.map { |seniority| seniority.split('-').map(&:capitalize).join('-') }
  end

  def filter_by_employment(param)
    param
  end

  def filters
    {
      applicant_tracking_system: filter_by_ats(@params[:ats]),
      date_posted: filter_by_when_posted(@params[:posted]),
      seniority: filter_by_seniority(@params[:seniority]),
      locations: filter_by_location(@params[:location]),
      roles: filter_by_role(@params[:role]),
      employment_type: filter_by_employment(@params[:employment])
    }.compact
  end

  def sort
    param = @params[:sort]&.to_sym
    Facet::SORT_OPTIONS.fetch(param, 'jobs.created_at DESC')
  end

  def wanted_opportunities
    query = @params[:query]
    query ? @opportunities.search_job(query) : @opportunities
  end
end
