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
  task devitjobs: :environment do
    Api::DevitJobs.new.import_jobs
  end

  desc "True up scraper"
  task scrape_true_up: :environment do
    ScrapeTrueUp.new.perform
  end

  desc "Import XML from Workable"
  task import_workable_xml: :environment do
    Xml::Workable.new.perform
  end
end
