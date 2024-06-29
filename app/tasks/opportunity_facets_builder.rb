# frozen_string_literal: true

class OpportunityFacetsBuilder < ApplicationTask
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
    build_facets
  end

  ###

  def build_facets
    @facets = sort_by_facets
    @facets += posted_facets
    @facets += seniority_facets
    @facets += location_facets
    @facets += role_facets
    @facets += employment_facets
    sorted(@facets)
  end

  def sort_by_facets
    return [] if @params[:query]

    attribute = 'sort'
    %w[title title_desc company company_desc created_at created_at_asc].map do |value|
      Facet.new(attribute:, value:, count: 0, url_params: @params, type: 'radio')
    end.compact
  end

  def posted_facets
    attribute = 'posted'
    date_cutoffs = Constants::DateConversion::CONVERT_TO_DAYS.transform_values { |v| v.days.ago.beginning_of_day }
    date_cutoffs.map do |period, cutoff|
      value = period.downcase.gsub(/last |within a /, '').gsub(' ', '-')
      count = facet_oppotunities(attribute).where(date_posted: cutoff..Date.today).count
      Facet.new(attribute:, value:, count:, url_params: @params, type: 'radio')
    end.compact
  end

  def seniority_facets
    attribute = 'seniority'
    facet_oppotunities(attribute).reorder(:seniority).group(:seniority).count.map do |seniority, count|
      next unless seniority

      value = seniority.downcase.split.first
      Facet.new(attribute:, value:, count:, url_params: @params, type: 'checkbox')
    end.compact
  end

  def location_facets
    attribute = 'location'
    facet_oppotunities(attribute).reorder(:'locations.city').group(:'locations.city').count.map do |location, count|
      value = location ? location.downcase.gsub(' ', '_') : 'remote'
      Facet.new(attribute:, value:, count:, url_params: @params, type: 'checkbox')
    end.compact
  end

  def role_facets
    attribute = 'role'
    facet_oppotunities(attribute).reorder(:'roles.name').group(:'roles.name').count.map do |role, count|
      next unless role

      value = role.downcase.split.first
      Facet.new(attribute:, value:, count:, url_params: @params, type: 'checkbox')
    end.compact
  end

  def employment_facets
    attribute = 'employment'
    facet_oppotunities(attribute).reorder(:employment_type).group(:employment_type).count.map do |employment, count|
      next unless employment

      value = employment
      Facet.new(attribute:, value:, count:, url_params: @params, type: 'checkbox')
    end.compact
  end

  def sorted(facets)
    facet_orders = %w[sort posted seniority location role employment]
    sorted_by_count(facets)
    facets.sort_by! { |facet| facet_orders.index(facet.attribute) }
  end

  def sorted_by_count(facets)
    facets.sort_by! do |facet|
      checked_criteria = facet.active?(@params) ? 0 : 1
      count_criteria = facet.type.eql?('radio') ? 0 : -facet.count
      facet.sortable_by_count? ? [checked_criteria, count_criteria] : [facet.position]
    end
  end

  def facet_oppotunities(exemption)
    FacetOpportunitiesFetcher.call(Job.all, @params.except(exemption))
  end
end
