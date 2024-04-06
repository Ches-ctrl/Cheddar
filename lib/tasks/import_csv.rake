namespace :import_csv do
  # Run this file using rake import_csv:command e.g. bright_network

  # -----------------------------
  # Applicant Tracking Systems
  # -----------------------------

  # TODO: Check whether this finds or creates the ATS

  desc "Import Applicant Tracking System data from CSV file"
  task applicant_tracking_systems: :environment do
    ats_csv = 'storage/csv/ats_systems.csv'
    AtsBuilder.new(ats_csv).build
  end

  # -----------------------------
  # Jobs
  # -----------------------------

  desc "Import Bright Network Jobs CSV"
  task bright_network: :environment do
    require 'csv_importer'

    # FIXME: get the csv file name from the command line
    # FIXME: the initializer does not take a filename
    # FIXME: add some error reporting/handling
    csv_importer = BrightNetworkImporter.new File.read(File.join(Rails.root, 'storage', 'new', 'BN_job_posting_urls.csv'))

    imported_jobs = csv_importer.import!

    # pp imported_jobs

    puts imported_jobs.count
  end
end
