namespace :admin do
  desc "Build all relevant companies and jobs"
  task build_companies_and_jobs: :environment do
    Build::AllCompanies.perform_later.then do
      Build::AllJobs.perform_later
    end
  end

  desc "Update existing company jobs"
  task update_existing_company_jobs: :environment do
    UpdateExistingCompanyJobs.new.perform
  end

  desc "Pull data from DevItJobs API"
  task devitjobs_api_pull: :environment do
    Scraper::DevItJob.new.perform
  end

  desc "True up scraper"
  task scrape_true_up: :environment do
    ScrapeTrueUpJob.new.perform
  end

  desc "Import XML from Workable"
  task import_workable_xml: :environment do
    Xml::WorkableJob.new.perform
  end

  desc "Scrape Monster"
  task scrape_monster: :environment do
    Scraper::MonsterJob.new.perform
  end
end
