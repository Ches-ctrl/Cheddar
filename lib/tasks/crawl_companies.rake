namespace :crawl_companies do
  desc "Crawl companies list for ats boards."
  task crawl: :environment do
    Crawlers::CompanyListCrawler.new.crawl_list(0, nil)
  end
end
