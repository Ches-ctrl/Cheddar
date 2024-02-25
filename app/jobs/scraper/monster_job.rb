class Scraper::MonsterJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Scrapers::MonsterService.new.scrape_page
  end
end
