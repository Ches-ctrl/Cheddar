# frozen_string_literal: true

class Facet
  ####
  #### accessors
  ####

  attr_accessor :attribute, :value, :position, :count, :url_params, :type

  ####
  #### constants
  ####

  ####
  #### extensions
  ####

  include ActiveModel::Model

  ####
  ####
  ####

  def active?(params)
    'checked' if params[attribute].eql?(value)
  end

  def current_param = { attribute => value }

  def public_attribute = attribute.titleize

  def public_value = value.titleize

  def presentation = "#{public_value.truncate(20)} (#{count})"

  def url(params)
    remove_filter_url = params.tap { |hs| hs.delete(attribute) }
    apply_filter_url =  params.merge(current_param)
    active?(params) ? remove_filter_url : apply_filter_url
  end

  ####
  #### self
  ####

  def self.set_attributes = @facets.map(&:attribute).uniq

  # private
end
