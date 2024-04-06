namespace :import_csv do
  # Run this file using rake import_csv:command e.g. bright_network

  # -----------------------------
  # Applicant Tracking Systems
  # -----------------------------

  # TODO: Check whether this finds or creates the ATS

  desc "Import Applicant Tracking System data from CSV file"
  task applicant_tracking_systems: :environment do
    ats_csv = 'storage/csv/ats_systems.csv'

    CSV.foreach(ats_csv, headers: true) do |row|
      ats_name = row["ats_name"]
      ats = ApplicantTrackingSystem.find_or_create_by(name: ats_name)

      attributes_to_update = {
        url_identifier: row["url_identifier"],
        website_url: row["website_url"],
        url_linkedin: row["url_linkedin"],
        base_url_main: row["base_url_main"],
        base_url_api: row["base_url_api"],
        url_all_jobs: row["url_all_jobs"],
        url_xml: row["url_xml"],
        url_rss: row["url_rss"],
        login: row["login"],
      }

      ats.update(attributes_to_update)

      if ats
        puts "Created ATS - #{ats.name}"
      else
        p "Error creating ATS: #{ats_name}"
      end
    end
  end

  desc "New CSV importing"
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
