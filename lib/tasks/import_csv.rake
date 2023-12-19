namespace :import_csv do
  # Run this file using rake import_csv:companies or rake import_csv:jobs

  desc "Import company data from CSV file"
  task companies: :environment do
    csv_file_path = 'storage/csv/Cheddar_Consulting_Test_Companies.csv'

    CSV.foreach(csv_file_path, headers: true) do |row|
      company_name = row["Company Name"]
      company = Company.find_by(company_name: company_name)

      if company
        company.update!(
          company_website_url: row["Website - General"],
          url_careers: row["Website - Careers"],
          url_linkedin: row["Website - LinkedIn"],
          location: row["Location"],
          industry: row["Industry"],
          industry_subcategory: row["Industry Sub-Category"],
        )
        p "#{company.company_name} was updated with the following fields: #{company.attributes}!"
      else
        Company.create!(
          company_name: row["Company Name"],
          company_website_url: row["Website - General"],
          url_careers: row["Website - Careers"],
          url_linkedin: row["Website - LinkedIn"],
          location: row["Location"],
          industry: row["Industry"],
          industry_subcategory: row["Industry Sub-Category"],
        )
        p "#{Company.last.company_name} was created with the following fields: #{Company.last.attributes}!"
      end
    end

    puts "Company data CSV import completed."
  end

  desc "Import Applicant Tracking System data from CSV file"
  task applicant_tracking_systems: :environment do
    csv_file_path = 'storage/csv/Cheddar_Consulting_Test_Jobs.csv'

    CSV.foreach(csv_file_path, headers: true) do |row|
      ats_name = row["Applicant Tracking System"]
      ats = ApplicantTrackingSystem.find_by(name: ats_name)

      if ats
        # ApplicantTrackingSystem.update!(
        #   name: row["Applicant Tracking System"],
        # )
        # p "#{ats.name} was updated with the following fields: #{ats.attributes}!"
        p "#{ats.name} already exists with the following fields: #{ats.attributes}!"
      else
        ApplicantTrackingSystem.create!(
          name: row["Applicant Tracking System"],
        )
        p "#{ApplicantTrackingSystem.last.name} was created with the following fields: #{ApplicantTrackingSystem.last.attributes}!"
      end
    end

    puts "ATS data CSV import completed."
  end

  # TODO: Validate ATS as unique
  # TODO: Validate ATS Format as unique

  desc "Import ATS Format data from CSV file"
  task ats_formats: :environment do
    csv_file_path = 'storage/csv/Cheddar_Consulting_Test_Jobs.csv'

    CSV.foreach(csv_file_path, headers: true) do |row|
      ats_format_name = row["ATS Format"]

      p "ATS Format Name: #{ats_format_name}"
      ats_format = AtsFormat.find_by(name: ats_format_name)

      p "ATS Format: #{ats_format}"

      if ats_format
        ats_system = ApplicantTrackingSystem.find_by(name: row["Applicant Tracking System"])

        p "ATS System: #{ats_system}"

        if ats_system
          AtsFormat.update!(
            applicant_tracking_system_id: ats_system.id,
            name: row["ATS Format"],
          )
          p "#{ats_format.name} was updated with the following fields: #{ats_format.attributes}!"
        else
          p "Error: Applicant Tracking System '#{row["Applicant Tracking System"]}' not found for ATS Format '#{ats_format_name}'."
        end
      else
        ats_system = ApplicantTrackingSystem.find_by(name: row["Applicant Tracking System"])

        if ats_system
          AtsFormat.create!(
            applicant_tracking_system_id: ats_system.id,
            name: row["ATS Format"],
          )
          p "#{AtsFormat.last.name} was created with the following fields: #{AtsFormat.last.attributes}!"
        else
          p "Error: ATS Format '#{ats_format_name}' not found, and Applicant Tracking System '#{row["Applicant Tracking System"]}' not found."
        end
      end
    end

    puts "ATS Format data CSV import completed."
  end

  desc "Import jobs data from CSV file"
  task jobs: :environment do
    csv_file_path = 'storage/csv/Cheddar_Consulting_Test_Jobs.csv'

    CSV.foreach(csv_file_path, headers: true) do |row|
      job_title = row["Title"]
      job = Job.find_by(job_title: job_title)


      company = Company.find_by(company_name: row["Company Name"])
      ats_system = ApplicantTrackingSystem.find_by(name: row["Applicant Tracking System"])

      # ats_format_name = row["ATS Format"]
      # p "ATS Format Name: #{ats_format_name}"

      # ats_format = AtsFormat.find_by(name: ats_format_name)
      # p "ATS Format: #{ats_format}"

      # ats_format = AtsFormat.find_by(name: row["ATS Format"])

      p "Company: #{company.company_name}"
      # p "ATS System: #{ats_system.name}"
      # p "ATS Format: #{ats_format.name}"

      if job
        job.update!(
          company_id: company.id,
          job_posting_url: row["Url"],
          job_description: "N/A",
          salary: row["Salary"].to_i,
          bonus: row["Bonus"].to_i,
          # application_deadline: row["Application Deadline"],
          employment_type: row["Employment Type (FT/PT)"],
          location: row["Location"],
          country: row["Country"],
          industry: row["Industry"],
          industry_subcategory: row["Industry Sub-Category"],
          seniority: row["Seniority"],
          office_status: row["Office Status"],
          # applicant_tracking_system_id: ats_system.id,
          # ats_format_id: ats_format.id,
          create_account: row["Create Account"],
          req_cv: row["CV"],
          req_cover_letter: row["Cover Letter"],
          req_online_assessment: row["Online Assessment"],
          req_video_interview: row["Video Interview"],
          req_first_round: row["1st Round Interview"],
          req_second_round: row["2nd Round Interview"],
          req_assessment_centre: row["Assessment Centre"]
        )
      else
        Job.create!(
          company_id: company.id,
          job_title: row["Title"],
          job_posting_url: row["Url"],
          job_description: "N/A",
          salary: row["Salary"].to_i,
          bonus: row["Bonus"].to_i,
          # application_deadline: row["Application Deadline"],
          employment_type: row["Employment Type (FT/PT)"],
          location: row["Location"],
          country: row["Country"],
          industry: row["Industry"],
          industry_subcategory: row["Industry Sub-Category"],
          seniority: row["Seniority"],
          office_status: row["Office Status"],
          # applicant_tracking_system_id: ats_system.id,
          # ats_format_id: ats_format.id,
          create_account: row["Create Account"],
          req_cv: row["CV"],
          req_cover_letter: row["Cover Letter"],
          req_online_assessment: row["Online Assessment"],
          req_video_interview: row["Video Interview"],
          req_first_round: row["1st Round Interview"],
          req_second_round: row["2nd Round Interview"],
          req_assessment_centre: row["Assessment Centre"]
        )
        p "#{Job.last.job_title} was created with the following attributes: #{Job.last.attributes}"
      end
    end

    puts "CSV import completed."
  end
end

# TODO: Add error handling
