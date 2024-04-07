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

  desc "Sort CSV - ats_identifiers"
  task sort_ats_identifiers: :environment do
    csv_data = CSV.read('storage/csv/ats_identifiers.csv', headers: true)
    p csv_data.length

    rows_as_strings = csv_data.map(&:to_s)
    rows_as_strings.map! { |row| row.gsub("\n", "") }
    sorted_data = rows_as_strings.sort

    CSV.open('storage/csv/ats_identifiers.csv', 'w', write_headers: true, headers: ['ats', 'ats_identifier']) do |csv|
      sorted_data.each { |row| csv << row.split(',') }
    end

    puts "CSV file sorted successfully."
  end

  # -----------------------------
  # Companies
  # -----------------------------

  desc "Sort CSV - company_url_list"
  task sort_company_url_list: :environment do
    csv = CSV.read('storage/csv/company_url_list.csv', headers: true)
    sorted = csv.sort_by { |row| row['company_url'] }

    CSV.open('storage/csv/company_url_list.csv', 'w') do |csv|
      csv << ['company_url']
      sorted.each { |row| csv << [row['company_url']] }
    end
  end

  # -----------------------------
  # Jobs
  # -----------------------------

  desc "Sort CSV - job_posting_urls"
  task sort_job_postings: :environment do
    csv = CSV.read('storage/csv/job_posting_urls.csv', headers: true)
    sorted = csv.sort_by { |row| row['job_posting_url'] }

    CSV.open('storage/csv/job_posting_urls.csv', 'w') do |csv|
      csv << ['job_posting_url']
      sorted.each { |row| csv << [row['job_posting_url']] }
    end
  end

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

  # TODO: Complete this task later (required significant additional functionality so paused for now) - NOT FULLY WORKING YET

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

  # -----------------------------
  # Users
  # -----------------------------

  desc "Import CSV - Users"
  task users: :environment do
    user_csv = 'storage/csv/sample_users.csv'
    UserBuilder.new(user_csv).build
    puts User.count
  end

end
