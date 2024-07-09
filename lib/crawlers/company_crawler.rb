require "cgi"
require "csv"

module Crawlers
  class CompanyCrawler < BaseCrawler
    # Requires a url string
    #
    # @param url [String]
    #
    # @param stubs_path [Pathname, NilClass]
    def initialize(url, stubs_path = File.join(File.dirname(__FILE__), "wordlists/careers_page_stubs.txt"))
      super
      @url_regex = Regexp.new('https?://(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b(?:[-a-zA-Z0-9@:%_\+.~#?&//=]*)')
      @ats_stubs = load_ats_stubs
      @board_extractor = BoardExtractor.new
    end

    private

    # Load and return stubs list from `storage/csv/ats_systems.csv`
    #
    # @return [Array<String>]
    def load_ats_stubs
      stubs = []
      ats_csv = CSV.parse(File.read(File.join(Rails.root, "storage/csv/ats_systems.csv")), headers: true)
      ats_csv.each do |row|
        next unless row['url_identifier'] != 'linkedin' && !row['url_identifier'].nil?

        ids = row['url_identifier'].split('|')
        stubs+=ids
      end
      return stubs
    end

    # Returns an array of urls from the given `source` string
    #
    # @param source [String]
    #
    # @return [Array<String>]
    def get_urls_from_source(source)
      source = CGI.unescape_html(source)
      return source.scan(@url_regex).uniq
    end

    # Returns `true` if the given url matches an ats stub
    #
    # @param url [String]
    #
    # @return [TrueClass, FalseClass]
    def ats?(url)
      @ats_stubs.each do |stub|
        return true if url.include?(stub)
      end
      return false
    end

    # Extract the board url from a job url.
    #
    # If the url extraction returns `nil`, the passed url will be returned unmodified.
    #
    # @param url [String]
    #
    # @ return [String]
    def extract_board_url(url)
      board_url = @board_extractor.extract(url)
      return board_url.nil? ? url : board_url
    end

    # Given an array, `urls`, return an array of ats urls according to `ats_stubs.txt`.
    #
    # @param urls [Array<String>]
    #
    # @return [Array<String>]
    def get_ats_urls(urls)
      ats_urls = []
      urls.each do |url|
        ats_urls.append(extract_board_url(url)) if ats?(url)
      end
      return ats_urls
    end

    # @param page [Spidr::Page]
    def scrape_page(page)
      urls = get_urls_from_source(page.body)
      @hits += get_ats_urls(urls)
    end

    def post_crawl_chores
      super
      @hits = @hits.uniq
    end
  end
end
