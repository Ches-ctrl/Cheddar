require 'rails_helper'

RSpec.describe Crawlers::BoardExtractor do
    describe ".extract" do
        it "returns the board url from a job url" do
            converter = Crawlers::BoardExtractor.new
            url = 'https://boards.greenhouse.io/strava/jobs/5589842'
            extracted = converter.extract(url)
            expect(extracted).to eql('https://boards.greenhouse.io/strava')
            
            url = 'https://globalenergymonitor.bamboohr.com/careers/72'
            extracted = converter.extract(url)
            expect(extracted).to eql('https://globalenergymonitor.bamboohr.com/careers')
        end
    end
    
end