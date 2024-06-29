# require_relative 'priority_agent'
require "spidr"

# Copying the `Spidr` entry point functions and setting them to use `PriorityAgent`
module PrioritySpidr
  extend Spidr::Settings::Proxy
  extend Spidr::Settings::Timeouts
  extend Spidr::Settings::UserAgent

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
