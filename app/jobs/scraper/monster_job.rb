module Scraper
  class MonsterJob < ApplicationJob
    queue_as :default

    def perform(*_args)
      Scraper::MonsterService.new.scrape_page
    end
  end
end
