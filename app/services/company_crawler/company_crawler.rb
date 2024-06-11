require_relative "../priority_spidr/priority_spidr"
require_relative "../priority_spidr/crawler"
require "cgi"
require "pathname"
require 'csv'
require 'uri'
ROOT = Pathname.new(__FILE__).parent.parent.parent.parent

class CompanyCrawler < Crawler
  # Requires a url string
  #
  # @param url [String]
  #
  # @param stubs_path [Pathname, NilClass]
  def initialize(url, stubs_path = Pathname.new(__FILE__).parent + "careers_page_stubs.txt") # rubocop:disable Style/StringConcatenation
    super(url, stubs_path)
    @url_regex = Regexp.new('https?://(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b(?:[-a-zA-Z0-9@:%_\+.~#?&//=]*)')
    @ats_stubs = load_ats_stubs
  end

  private

  # Load and return stubs list from `storage/csv/ats_systems.csv`
  #
  # @return [Array<String>]
  def load_ats_stubs
    stubs = []
    ats_csv = CSV.parse(File.read(ROOT + "storage" + "csv" + "ats_systems.csv"), headers: true) # rubocop:disable Style/StringConcatenation
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

  # Given an array, `urls`, return an array of ats urls according to `ats_stubs.txt`.
  #
  # @param urls [Array<String>]
  #
  # @return [Array<String>]
  def get_ats_urls(urls)
    ats_urls = []
    urls.each do |url|
      ats_urls.append(url) if ats?(url)
    end
    return ats_urls
  end

  # @param page [Spidr::Page]
  def process_page(page)
    puts page.response.code
    urls = get_urls_from_source(page.body)
    @hits += get_ats_urls(urls)
  end
end
