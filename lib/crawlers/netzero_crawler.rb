require_relative "../priority_spidr/priority_spidr"
require_relative "base_crawler"
require_relative "netzero_hit"
require "cgi"

module Crawlers
  class NetzeroCrawler < BaseCrawler
    # Requires a url string
    #
    # @param url [String]
    #
    # @param stubs_path [Pathname, NilClass]
    def initialize(url, stubs_path = File.join(File.dirname(__FILE__), "wordlists/netzero_priority_stubs.txt"))
      super(url, stubs_path)
      @netzero_stubs = load_stubs(File.join(File.dirname(__FILE__), "wordlists/netzero_key_terms.txt"))
    end

    private

    # Scores `page` and adds it to `@hits` if it's above 0
    #
    # @param page [Spidr::Page]
    def score_page(page)
      source = page.body.downcase
      hit = NetzeroHit.new(page.url.to_s)
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
