require_relative "../priority_spidr/priority_spidr"
require "cgi"
require "pathname"

# TODO: Add time limit parameter
# TODO: There's no realtime progress update
class CompanyCrawler
  attr_reader :ats_hits

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

  public

  # Start crawling company website for its ats board
  def crawl
    puts "Beginning crawl of #{@starting_url}..."
    Spidr.site(@starting_url, strip_fragments: true, strip_query: true, robots: false) do |spider|
      spider.priority_stubs = @careers_page_stubs
      spider.every_page do |page|
        # quit crawling if we found the board
        spider.pause! unless @ats_hits.empty? # TODO: make number of hits to quit variable
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
