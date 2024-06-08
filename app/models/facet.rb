# frozen_string_literal: true

class Facet
  ####
  #### accessors
  ####

  attr_accessor :attribute, :value, :position, :count, :url_params, :type

  ####
  #### constants
  ####

  SORT_PRESENTATIONS = {
    title: 'Title (A-Z)',
    title_desc: 'Title (Z-A)',
    company: 'Company (A-Z)',
    company_desc: 'Company (Z-A)',
    created_at: 'Newest',
    created_at_asc: 'Oldest'
  }

  SORT_OPTIONS = {
    title: 'jobs.title ASC',
    title_desc: 'jobs.title DESC',
    company: 'companies.name ASC',
    company_desc: 'companies.name DESC',
    created_at: 'jobs.created_at DESC',
    created_at_asc: 'jobs.created_at ASC'
  }.freeze

  ####
  #### extensions
  ####

  include ActiveModel::Model

  ####
  ####
  ####

  def active?(params)
    'checked' if params[attribute]&.include?(value)
  end

  def current_param = { url_attribute => value }

  def public_attribute = attribute.titleize

  def public_value = value.titleize

  def multi_attribute?
    type.eql?('checkbox')
  end

  def presentation
    sort_presentation || "#{public_value.truncate(20)} (#{count})"
  end

  def sort_presentation
    return unless attribute.eql?('sort')

    SORT_PRESENTATIONS.fetch(value.to_sym)
  end

  def url(params)
    dup_params = params.dup
    remove_filter_url = remove_value_from_hash(dup_params, attribute, value)
    apply_filter_url =  dup_params.merge(current_param)
    removable?(params) ? remove_filter_url : apply_filter_url
  end

  ####
  #### self
  ####

  def self.set_attributes = @facets.map(&:attribute).uniq

  private

  def url_attribute
    multi_attribute? ? "#{attribute}[]" : attribute
  end

  def removable?(params)
    active?(params) && multi_attribute?
  end

  def remove_value_from_hash(params, attribute, value)
    if params.key?(attribute) && params[attribute].is_a?(Array)
      filtered_values = params[attribute].reject { |item| item.eql?(value) }
      filtered_values.empty? ? remove_attribute_from_hash(params, attribute) : params.merge!({ attribute => filtered_values })
    else
      remove_attribute_from_hash(params, attribute)
    end
  end

  def remove_attribute_from_hash(params, attribute)
    params.tap { |hs| hs.delete(attribute) }
  end
end
