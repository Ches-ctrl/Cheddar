require "cgi"
require "csv"

module Crawlers
  # Base class for crawlers
  class BaseCrawler
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
      @priority_stubs = load_stubs(stubs_path)
      @agent = nil
      # Initialize limts to `nil`
      set_limits
    end

    private

    # Load priority stubs to use.
    # Expects file format to be plain text, one stub per line.
    # If `path` is `nil`, an empty array will be returned.
    #
    # @param path [String]
    #
    # @return [Array<String>]
    def load_stubs(path)
      return [] if path.nil?

      return File.new(path).readlines.map(&:chomp)
    end

    # Return current timestamp.
    #
    # @return [Float]
    def current_time
      return Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end

    # Return elapsed time.
    #
    # @return [Float]
    def elapsed_time
      return current_time - @start_time
    end

    # Return `true` if max crawl exceeded.
    #
    # @param agent [Spidr::PriorityAgent]
    #
    # @return [TrueClass, FalseClass]
    def max_crawl_exceeded?
      return false unless !@max_crawl.nil? && @max_crawl < @agent.history.length

      return true
    end

    # Return `true` if max time exceeded.
    #
    # @return [TrueClass, FalseClass]
    def max_time_exceeded?
      return false unless !@max_time.nil? && @max_time <= elapsed_time

      return true
    end

    # Return `true` if max hits exceeded.
    #
    # @return [TrueClass, FalseClass]
    def max_hits_exceeded?
      return false unless !@max_hits.nil? && @hits.length >= @max_hits

      return true
    end

    # Return `true` if any limit is exceeded.
    #
    # @param agent [Spidr::PriorityAgent]
    #
    # @return [TrueClass, FalseClass]
    def limits_exceeded?
      return max_crawl_exceeded? || max_time_exceeded? || max_hits_exceeded?
    end

    # Stop crawl due to crawl limits having been exceeded.
    #
    # @param agent [PriorityAgent]
    def limits_exceeded
      puts "Scan limits exceeded."
      puts "Scanned #{@agent.history.length} pages in #{elapsed_time.round(2)}s."
      @agent.pause!
    end

    # Print info about current page being crawled.
    #
    # @param page [Spidr::Page]
    def page_status(page)
      puts "Scraping `#{page.url}`"
      puts "Status code: `#{page.response.code}`"
    end

    # Return the domain from a url, stripping `www.` if present.
    # i.e. https://www.website.com -> website.com
    #
    # @param url [String]
    #
    # @return [String]
    def url_to_domain(url)
      return URI(url).host.delete_prefix('www.')
    end

    # Return a list of valid hosts from the given url.
    #
    # @param url [String]
    #
    # @return [Array<String>]
    def valid_hosts(url)
      domain = url_to_domain(url)
      return [domain, /[a-zA-Z\.]+#{domain}/]
    end

    # Perform pre-crawl actions and setup.
    def pre_crawl_chores
      @start_time = current_time
      puts "Beginning crawl of `#{@starting_url}`..."
    end

    # Defines the action loop for each page.
    #
    # @param agent [PriorityAgent::PriorityAgent]
    def every_page
      @agent.priority_stubs = @priority_stubs
      @agent.every_page do |page|
        limits_exceeded if limits_exceeded?
        page_status(page)
        scrape_page(page)
      end
    end

    # Override to implement per page behavior.
    #
    # @param page [Spidr::Page]
    def scrape_page(page)
      raise NotImplementedError
    end

    public

    # Set the limit values for the crawler.
    # Pass a value of `nil` for a limit to be ignored.
    #
    # @param max_crawl [Integer, NilClass]
    #
    # @param max_time [Float, NilClass]
    #
    # @param max_hits [Integer, NilClass]
    def set_limits(max_crawl = nil, max_time = nil, max_hits = nil)
      @max_crawl = max_crawl
      @max_time = max_time
      @max_hits = max_hits
    end

    # Start crawling with the specified limits, if any.
    # Returns the contents of `@hits`.
    #
    # @return [Array]
    def crawl
      pre_crawl_chores
      PriorityAgent.start_at(@starting_url,
                             hosts: valid_hosts(@starting_url),
                             strip_fragments: true,
                             strip_query: true, robots: false) do |agent|
        @agent = agent
        every_page
      end
      return @hits
    end
  end
end
