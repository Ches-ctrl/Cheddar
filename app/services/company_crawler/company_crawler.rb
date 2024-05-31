require_relative "../priority_spidr/priority_spidr"
require "cgi"
require "pathname"

# TODO: Add time limit parameter
# TODO: There's no realtime progress update
class CompanyCrawler
  attr_reader :ats_hits
  attr_accessor :max_crawl, :max_time

  # Requires a url string
  def initialize(url)
    @starting_url = url
    @url_regex = Regexp.new('https?://(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b(?:[-a-zA-Z0-9@:%_\+.~#?&//=]*)')
    @ats_stubs = (Pathname.new(__FILE__).parent + "ats_stubs.txt").readlines.map(&:chomp) # rubocop:disable Style/StringConcatenation
    @careers_page_stubs = (Pathname.new(__FILE__).parent + "careers_page_stubs.txt").readlines.map(&:chomp) # rubocop:disable Style/StringConcatenation
    @ats_hits = []
  end

  private

  # Returns an array of urls from the given `source` string
  def get_urls_from_source(source)
    source = CGI.unescape_html(source)
    return source.scan(@url_regex).uniq
  end

  # Given an array, `urls`, return an array of ats urls according to `ats_stubs.txt`.
  def get_ats_urls(urls)
    ats_urls = []
    urls.each do |url|
      @ats_stubs.each do |stub|
        next unless url.include?(stub)

        ats_urls.append(url)
        break
      end
    end
    return ats_urls
  end

  # Get current timestamp
  def current_time
    return Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end

  # Return elapsed time
  def elapsed_time
    return current_time - @start_time
  end

  # Return `true` if max crawl exceeded
  def max_crawl_exceeded?(spider)
    return false unless !@max_crawl.nil? && @max_crawl < spider.history.length

    return true
  end

  # Return `true` if max time exceeded
  def max_time_exceeded?
    return false unless !@max_time.nil? && @max_time <= elapsed_time

    return true
  end

  # Return `true` if limits exceeded
  def limits_exceeded?(spider)
    return max_crawl_exceeded?(spider) || max_time_exceeded? || !@ats_hits.empty? # TODO: make number of hits to quit variable
  end

  public

  # Start crawling company website for its ats board.
  # `max_crawl`: optional max number of urls to scan before quitting
  # `max_time`: optional max number of seconds to crawl before quitting
  def crawl(max_crawl: nil, max_time: nil)
    @max_crawl = max_crawl
    @max_time = max_time
    @start_time = current_time
    puts "Beginning crawl of #{@starting_url}..."
    Spidr.site(@starting_url, strip_fragments: true, strip_query: true, robots: false) do |spider|
      spider.priority_stubs = @careers_page_stubs
      spider.every_page do |page|
        # quit crawling if limits exceed
        spider.pause! if limits_exceeded?(spider)
        puts "Scanning `#{page.url}`"
        urls = get_urls_from_source(page.body)
        @ats_hits += get_ats_urls(urls)
      end
    end
    if @ats_hits.empty?
      puts "Could not find any ats urls."
    else
      puts "Found ats urls: #{@ats_hits}"
    end
  end
end
