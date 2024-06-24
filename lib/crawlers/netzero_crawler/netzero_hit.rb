module Crawlers
  # Represent a possible netzero page hit.
  # The score is based on the number of key term stubs found on the page.
  class NetzeroHit
    # The url of the page
    attr_accessor :url
    # The stubs found on the page
    attr_accessor :stubs

    # @param url [String]
    def initialize(url)
      self.url = url
      self.stubs = []
    end

    # The number of stubs for this hit
    #
    # @return [Integer]
    def score
      return stubs.length
    end
  end
end
