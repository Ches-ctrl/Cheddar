namespace :admin do
  desc "Build all relevant companies and jobs"
  task build_all_companies_and_jobs: :environment do
    Build::AllCompaniesJob.perform_companies_and_jobs
  end

  desc "Update existing company jobs"
  task update_existing_company_jobs: :environment do
    UpdateExistingCompanyJobs.new.perform
  end

  desc "Pull data from DevItJobs API"
  task devitjobs_api_pull: :environment do
    Scraper::DevitJobsJob.new.perform
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
