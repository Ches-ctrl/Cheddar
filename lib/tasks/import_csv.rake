namespace :import_csv do
  # Run this file using rake import_csv:command e.g. bright_network

  # -----------------------------
  # Applicant Tracking Systems
  # -----------------------------

  desc "Import CSV - Applicant Tracking Systems"
  task applicant_tracking_systems: :environment do
    ats_csv = 'storage/csv/ats_systems.csv'
    AtsBuilder.new(ats_csv).build
    puts ApplicantTrackingSystem.count
  end

  # -----------------------------
  # Jobs
  # -----------------------------

  desc "Import CSV - Bright Network Jobs"
  task bright_network: :environment do
    require 'csv_importer'

    # FIXME: get the csv file name from the command line
    # FIXME: the initializer does not take a filename
    # FIXME: add some error reporting/handling
    csv_importer = BrightNetworkImporter.new File.read(File.join(Rails.root, 'storage', 'new', 'BN_job_posting_urls.csv'))

    imported_jobs = csv_importer.import!

    puts imported_jobs.count
  end

  desc "Import CSV - job_posting_urls"
  task job_posting_urls: :environment do
    jobs_csv = 'storage/csv/job_posting_urls.csv'

    puts Job.count
    puts "Creating new jobs..."

    CSV.foreach(jobs_csv, headers: true) do |row|
      url = row['job_posting_url']
      CreateJobByUrl.new(url).call
    end

    puts Job.count
  end
end
