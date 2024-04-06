namespace :import_csv do
  # Run this file using rake import_csv:companies or rake import_csv:jobs

  # TODO: At the moment it doesn't correctly identify whether objects are created or updated (fix this)

  # -----------------------------
  # Applicant Tracking Systems
  # -----------------------------

  desc "Import Applicant Tracking System data from CSV file"
  task applicant_tracking_systems: :environment do
    csv_file_path = 'storage/csv/Cheddar_Consulting_Test_Jobs.csv'
    counter = 0

    CSV.foreach(csv_file_path, headers: true) do |row|
      ats_name = row["Applicant Tracking System"]
      ats = find_or_create_applicant_tracking_system(ats_name)

      if ats
        p "#{ats.new_record? ? 'Created' : 'Updated'} ATS Format - #{ats.name}"
        counter += 1
      else
        p "Error creating ATS Format: #{ats_name}"
      end
    end

    p "Created / Updated #{counter} Applicant Tracking Systems."
    p "-----------------------------"
  end

  def find_or_create_applicant_tracking_system(name)
    ats = ApplicantTrackingSystem.find_or_initialize_by(name:)

    ats.save unless ats.persisted?

    ats
  end

  # -----------------------------
  # Jobs
  # -----------------------------

  desc "Import jobs data from CSV file"
  task jobs: %i[environment companies] do
    csv_file_path = 'storage/csv/Cheddar_Consulting_Test_Jobs.csv'
    counter = 0

    CSV.foreach(csv_file_path, headers: true) do |row|
      job_title = row["Title"]
      job = find_or_create_job(job_title, row)

      if job
        p "#{job.new_record? ? 'Created' : 'Updated'} Job - #{job.job_title}"
        counter += 1
      else
        p "Error creating job: #{job_title}"
      end
    end

    p "Created / Updated #{counter} jobs."
    puts "CSV import completed."
  end

  desc "New CSV importing"
  task new: :environment do
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
