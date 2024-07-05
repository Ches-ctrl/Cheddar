require 'rails_helper'

RSpec.describe Crawlers::CompanyCrawler do
    describe ".crawl" do
        it "returns https://boards.greenhouse.io/strava" do
            crawler = Crawlers::CompanyCrawler.new("https://strava.com")
            max_crawl = 10
            max_time = 10
            max_hits = 1
            crawler.set_limits(max_crawl, max_time, max_hits)
            hits = crawler.crawl
            expect(hits.length).to eql(1)
            expect(hits[0]).to eql("https://boards.greenhouse.io/strava")
        end
        
        it "returns https://globalenergymonitor.bamboohr.com/careers" do
            crawler = Crawlers::CompanyCrawler.new('https://globalenergymonitor.org')
            max_crawl = 10
            max_time = 10
            max_hits = 1
            crawler.set_limits(max_crawl, max_time, max_hits)
            hits = crawler.crawl
            expect(hits.length).to eql(1)
            expect(hits[0]).to eql('https://globalenergymonitor.bamboohr.com/careers')
        end
    end
end