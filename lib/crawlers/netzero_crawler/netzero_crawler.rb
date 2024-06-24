require_relative "../../priority_spidr/priority_spidr"
require_relative "../base_crawler"
require_relative "netzero_hit"
require "cgi"
require "pathname"

module Crawlers
  class NetzeroCrawler < BaseCrawler
    ROOT = Pathname.new(__FILE__).parent.parent.parent.parent
    # Requires a url string
    #
    # @param url [String]
    #
    # @param stubs_path [Pathname, NilClass]
    def initialize(url, stubs_path = Pathname.new(__FILE__).parent + "priority_stubs.txt") # rubocop:disable Style/StringConcatenation
      super(url, stubs_path)
      @netzero_stubs = load_stubs(Pathname.new(__FILE__).parent + "key_terms.txt") # rubocop:disable Style/StringConcatenation
    end

    private

    # Scores `page` and adds it to `@hits` if it's above 0
    #
    # @param page [Spidr::Page]
    def score_page(page)
      source = page.body.downcase
      hit = NetzeroHit.new(page.url)
      @netzero_stubs.each do |stub|
        if source.downcase.include?(stub)
          puts stub
          hit.stubs << stub
        end
      end
      return unless hit.score.positive?

      hits << hit
    end

    # @param page [Spidr::Page]
    def process_page(page)
      score_page(page)
    end

    public

    # Returns hits, sorted descending by score
    #
    # @return [Array<NetzeroHit>]
    def sorted_hits
      return @hits.sort_by { |hit| -hit.score }
    end
  end
end
