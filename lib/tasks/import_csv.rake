namespace :import_csv do
  # Run this file using rake import_csv:companies or rake import_csv:jobs

  # TODO: At the moment it doesn't correctly identify whether objects are created or updated (fix this)

  # -----------------------------
  # Companies
  # -----------------------------

  desc "Import company data from CSV file"
  task companies: :environment do
    csv_file_path = 'storage/csv/Cheddar_Consulting_Test_Companies.csv'
    counter_created = 0
    counter_updated = 0

    CSV.foreach(csv_file_path, headers: true) do |row|
      company_name = row["Company Name"]
      company = Company.find_or_create_by(company_name:)

      attributes_to_update = {
        company_website_url: row["Website - General"],
        url_careers: row["Website - Careers"],
        url_linkedin: row["Website - LinkedIn"],
        location: row["Location"],
        industry: row["Industry"],
        industry_subcategory: row["Industry Sub-Category"]
      }

      if company.new_record?
        company.update(attributes_to_update)
        p "Created Company - #{company.company_name}"
        counter_created += 1
      else
        p "Updated Company - #{company.company_name}"
        counter_updated += 1
      end
    end

    p "Created #{counter_created} companies."
    p "Updated #{counter_updated} companies."
    p "-----------------------------"
  end

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
    csv_importer = CsvImporter.new File.read(File.join(Rails.root, 'storage', 'new', 'BN_job_posting_urls.csv'))

    imported_jobs = csv_importer.import!

    pp imported_jobs

    puts imported_jobs.count
  end

  # TODO: Fix this now that we no longer have ATS Format as a separate model

  # def find_or_create_job(job_title, row)
  #   company = Company.find_by(company_name: row["Company Name"])
  #   # p "Company: #{company}"
  #   ats_format = AtsFormat.find_by(name: row["ATS Format"])
  #   # p "ATS Format: #{ats_format}"
  #   ats_system = ApplicantTrackingSystem.find_by(id: ats_format.applicant_tracking_system_id)
  #   # ats_system = ApplicantTrackingSystem.find_by(name: row["Applicant Tracking System"])
  #   # p "ATS System: #{ats_system}"

  #   job_attributes = {
  #     company_id: company.id,
  #     job_posting_url: row["Url"],
  #     job_description: "N/A",
  #     salary: row["Salary"].to_i,
  #     bonus: row["Bonus"].to_i,
  #     employment_type: row["Employment Type (FT/PT)"],
  #     location: row["Location"],
  #     country: row["Country"],
  #     industry: row["Industry"],
  #     industry_subcategory: row["Industry Sub-Category"],
  #     seniority: row["Seniority"],
  #     office_status: row["Office Status"],
  #     create_account: row["Create Account"],
  #     req_cv: row["CV"],
  #     req_cover_letter: row["Cover Letter"],
  #     req_online_assessment: row["Online Assessment"],
  #     req_video_interview: row["Video Interview"],
  #     req_first_round: row["1st Round Interview"],
  #     req_second_round: row["2nd Round Interview"],
  #     req_assessment_centre: row["Assessment Centre"]
  #   }

  #   if ats_system
  #     # p "ATS System: #{ats_system}"
  #     job_attributes[:applicant_tracking_system_id] = ats_system.id
  #     # p "Job ATS System ID: #{job_attributes[:applicant_tracking_system_id]}"
  #   end

  #   if ats_format
  #     # p "ATS Format: #{ats_format}"
  #     job_attributes[:ats_format_id] = ats_format.id
  #     # p "Job ATS Format ID: #{job_attributes[:ats_format_id]}"
  #   end

  #   job = Job.find_or_initialize_by(job_title: job_title)
  #   job.update(job_attributes)
  #   job
  # end
end
