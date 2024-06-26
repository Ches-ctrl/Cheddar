require 'rails_helper'

RSpec.describe Crawlers::CompanyCrawler do
    describe ".crawl" do
        it "returns https://boards.greenhouse.io/strava" do
            crawler = Crawlers::CompanyCrawler.new("https://strava.com")
            hits = crawler.crawl(10, 10, 1)
            expect(hits[0]).to eql("https://boards.greenhouse.io/strava")
        end
    end
end