# frozen_string_literal: true

require 'spidr/settings/proxy'
require 'spidr/settings/timeouts'
require 'spidr/settings/user_agent'
require_relative 'priority_agent'

# Copying the `Spidr` entry point functions and setting them to use `PriorityAgent`
module Spidr
  extend Settings::Proxy
  extend Settings::Timeouts
  extend Settings::UserAgent

  #
  # Specifies whether `robots.txt` should be honored globally.
  #
  # @return [Boolean]
  #
  # @since 0.5.0
  #
  def self.robots?
    @robots ||= false
    @robots
  end

  #
  # Enables or disables `robots.txt` globally.
  #
  # @param [Boolean] mode
  #
  # @return [Boolean]
  #
  # @since 0.5.0
  #
  def self.robots=(mode)
    @robots = mode
  end

  #
  # @see Agent.start_at
  #
  def self.start_at(url, ...)
    PriorityAgent.start_at(url, ...)
  end

  #
  # @see Agent.host
  #
  def self.host(name, ...)
    PriorityAgent.host(name, ...)
  end

  #
  # @see Agent.domain
  #
  # @since 0.7.0
  #
  def self.domain(name, ...)
    PriorityAgent.domain(name, ...)
  end

  #
  # @see Agent.site
  #
  def self.site(url, ...)
    PriorityAgent.site(url, ...)
  end

  #
  # @abstract
  #
  def self.robots
  end
end
