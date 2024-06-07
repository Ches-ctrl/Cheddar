# frozen_string_literal: true

class OpportunityFacetsBuilder < ApplicationTask
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
    build_facets
  end

  def build_facets
    @facets = {}
    build_posted_array
    build_seniority_array
    build_location_array
    build_role_array
    build_employment_array
    @facets
  end

  def build_posted_array
    date_cutoffs = Constants::DateConversion::CONVERT_TO_DAYS.transform_values { |v| v.days.ago.beginning_of_day }
    results = date_cutoffs.map do |period, cutoff|
      period_id = period.downcase.gsub(/last |within a /, '').gsub(' ', '-')
      count = @opportunities.where(date_posted: cutoff..Date.today).count
      params = @params[:posted] ? @params[:posted].include?(period_id) : period == 'Any time'

      ['radio', period, period_id, count, params]
    end.compact
    @facets['posted'] = results
  end

  def build_seniority_array
    results = @opportunities.group(:seniority).count.map do |seniority, count|
      next unless seniority

      seniority_id = seniority.downcase.split.first
      params = @params[:seniority]&.include?(seniority_id)

      ['checkbox', seniority, seniority_id, count, params]
    end.compact
    @facets['seniority'] = sort_by_count_desc(results)
  end

  def build_location_array
    results = @opportunities.group(:'locations.city').count.map do |location, count|
      location_id = location ? location.downcase.gsub(' ', '_') : 'remote'
      params = location ? @params[:location]&.include?(location_id) : @params[:location]&.include?('remote')
      location ||= 'Remote'

      ['checkbox', location, location_id, count, params]
    end.compact
    @facets['location'] = sort_by_count_desc(results)
  end

  def build_role_array
    results = @opportunities.group(:'roles.name').count.map do |role, count|
      next unless role

      role_id = role
      params = @params[:role]&.include?(role_id)
      role = role.titleize

      ['checkbox', role, role_id, count, params]
    end.compact
    @facets['role'] = sort_by_count_desc(results)
  end

  def build_employment_array
    results = @opportunities.group(:employment_type).count.map do |employment, count|
      next unless employment

      employment_id = employment.downcase.gsub('-', '_')
      params = @params[:employment]&.include?(employment_id)

      ['checkbox', employment, employment_id, count, params]
    end.compact
    @facets['employment'] = sort_by_count_desc(results)
  end

  def sort_by_count_desc(data)
    data.sort_by { |item| -item[3] }
  end
end
