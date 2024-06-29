namespace :admin do
  desc "Build all relevant companies and jobs"
  task build_all_companies_and_jobs: :environment do
    Build::AllCompaniesJob.perform_companies_and_jobs
  end

  desc "Check number of jobs by ATS"
  task no_of_jobs: :environment do
    Builders::NoOfJobs.new.analyse
  end

  desc "Pull data from DevItJobs API"
  task devitjobs: :environment do
    Importer::Api::DevitJobs.new.call
  end

  desc "Scrape data from TrueUp"
  task scrape_true_up: :environment do
    Importer::Scraper::TrueUp.new.perform
  end

  desc "Import XML from Workable"
  task import_workable_xml: :environment do
    Importer::Xml::Workable.new.perform
  end

  desc "Update existing company jobs"
  task update_existing_company_jobs: :environment do
    Updater::ExistingCompanyJobs.new.perform
  end

  desc "Export CSV version of record type"
  task export_to_csv: :environment do
    Csv::ExportToCsv.new.to_csv
  end
end
