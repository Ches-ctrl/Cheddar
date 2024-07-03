require 'rails_helper'

RSpec.describe Crawlers::UrlTranslator do
    describe ".translate?" do
        it "checks if url is translatable" do
            translator = Crawlers::UrlTranslator.new('smartrecruiters', {'jobs'=>'careers'})
            url = 'https://jobs.smartrecruiters.com/procoretechnologies'
            expect(translator.translate?(url)).to eql(true)
            url = 'https://boards.greenhouse.io/strava'
            expect(translator.translate?(url)).to eql(false)
        end
    end
    
    describe ".translate" do
        it "translates the given url" do
            translator = Crawlers::UrlTranslator.new('smartrecruiters', {'jobs'=>'careers'})
            url = 'https://jobs.smartrecruiters.com/procoretechnologies'
            translated_url = 'https://careers.smartrecruiters.com/procoretechnologies'
            expect(translator.translate(url)).to eql(translated_url)
            url = 'https://boards.greenhouse.io/strava'
            expect(translator.translate(url)).to eql(url)
        end
    end
end