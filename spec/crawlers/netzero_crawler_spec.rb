require 'rails_helper'

RSpec.describe Crawlers::NetzeroCrawler do
    describe ".crawl" do
        it "returns a `NetzeroHit` object with a score of 6 pointing to 'https://stripe.com/climate'" do
            crawler = Crawlers::NetzeroCrawler.new("https://stripe.com")
            max_crawl = nil
            max_time = 10
            max_hits = nil
            crawler.set_limits(max_crawl, max_time, max_hits)
            crawler.crawl
            top_hit = crawler.sorted_hits[0]
            expect(top_hit.url).to eql("https://stripe.com/climate")
            expect(top_hit.score).to eql(6)
        end
    end
end