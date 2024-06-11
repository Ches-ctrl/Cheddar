require_relative 'priority_spidr'
require "cgi"
require "pathname"
require 'csv'
require 'uri'

# Base class for crawlers
class Crawler
  # Array for storing whatever the crawler is looking for
  # @return [Array]
  attr_reader :hits

  # Crawl limiters

  # @return [Integer, NilClass]
  attr_accessor :max_crawl
  # @return [Float, NilClass]
  attr_accessor :max_time
  # @return [Integer, NilClass]
  attr_accessor :max_hits

  # @param url [String]
  #
  # @param stubs_path [Pathname, NilClass]
  def initialize(url, stubs_path = nil)
    @starting_url = url
    @hits = []
    if stubs_path.nil?
      puts "No priority stub path given."
      @priority_stubs = []
    else
      @priority_stubs = load_priority_stubs(stubs_path)
    end
  end

  private

  # Load priority stubs to use.
  # Expects file format to be plain text, one stub per line
  #
  # @param path [Pathname]
  #
  # @return [Array<String>]
  def load_priority_stubs(path)
    return path.readlines.map(&:chomp)
  end

  # Get current timestamp
  #
  # @return [Float]
  def current_time
    return Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end

  # Return elapsed time
  #
  # @return [Float]
  def elapsed_time
    return current_time - @start_time
  end

  # Return `true` if max crawl exceeded
  #
  # @param agent [Spidr::PriorityAgent]
  #
  # @return [TrueClass, FalseClass]
  def max_crawl_exceeded?(agent)
    return false unless !@max_crawl.nil? && @max_crawl < agent.history.length

    return true
  end

  # Return `true` if max time exceeded
  #
  # @return [TrueClass, FalseClass]
  def max_time_exceeded?
    return false unless !@max_time.nil? && @max_time <= elapsed_time

    return true
  end

  # Return `true` if max hits exceeded
  #
  # @return [TrueClass, FalseClass]
  def max_hits_exceeded?
    return false unless !@max_hits.nil? && @hits.length >= @max_hits

    return true
  end

  # Return `true` if any limit is exceeded
  #
  # @param agent [Spidr::PriorityAgent]
  #
  # @return [TrueClass, FalseClass]
  def limits_exceeded?(agent)
    return max_crawl_exceeded?(agent) || max_time_exceeded? || max_hits_exceeded?
  end

  # Return the domain from a url, stripping `www.` if present
  # i.e. https://www.website.com -> website.com
  #
  # @param url [String]
  #
  # @return [String]
  def url_to_domain(url)
    puts URI(url).host.delete_prefix('www.')
    return URI(url).host.delete_prefix('www.')
  end

  # Override to implement per page behavior
  #
  # @param page [Spidr::Page]
  def process_page(page)
    raise NotImplementedError
  end

  public

  # Start crawling with the specified limits, if any.
  # Returns the contents of `@hits`.
  #
  # @param max_crawl [Integer, NilClass]
  #
  # @param max_time [Float, NilClass]
  #
  # @param max_hits [Integer, NilClass]
  #
  # @return [Array]
  def crawl(max_crawl = nil, max_time = nil, max_hits = nil)
    @max_crawl = max_crawl
    @max_time = max_time
    @max_hits = max_hits
    @start_time = current_time
    domain = url_to_domain(@starting_url)
    puts "Beginning crawl of `#{@starting_url}`..."
    Spidr.start_at(@starting_url, hosts: [domain, /[a-zA-Z\.]+#{domain}/], strip_fragments: true, strip_query: true, robots: false) do |agent|
      agent.priority_stubs = @priority_stubs
      agent.every_page do |page|
        # quit crawling if limits exceeded
        if limits_exceeded?(agent)
          puts "Scan limits exceeded."
          puts "Scanned #{agent.history.length} pages in #{elapsed_time.round(2)}s."
          agent.pause!
        end
        puts "Scraping `#{page.url}`"
        process_page(page)
      end
    end
    return @hits
  end
end
