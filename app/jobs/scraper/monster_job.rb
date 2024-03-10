module Scraper
  class MonsterJob < ApplicationJob
    queue_as :default

    def perform(*_args)
      Scrapers::MonsterService.new.scrape_page
    end
  end
end
