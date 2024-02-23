class Scrapper::MonsterJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Scrappers::MonsterService.new.scrape_page
  end
end
