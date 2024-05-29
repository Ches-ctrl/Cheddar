namespace :import_csv do
  # -----------------------------
  # Applicant Tracking Systems
  # -----------------------------

  # TODO: Add a way to update existing ATSs (e.g. if they change their url format or url_identifiers etc.)

  desc "Import CSV - Applicant Tracking Systems"
  task applicant_tracking_systems: :environment do
    Builders::AtsBuilder.new.build
  end

  # -----------------------------
  # Companies
  # -----------------------------

  desc "Import CSV - company_urls"
  task company_urls: :environment do
    company_list = AtsIdentifiers.load

    company_csv = 'storage/new/company_urls.csv'

    puts Company.count
    puts "Creating new companies..."

    CSV.foreach(company_csv, headers: true) do |row|
      url = row['company_url']
      ats, company = Url::CreateCompanyFromUrl.new(url).create_company
      company_list[ats.name] << company.ats_identifier if company&.persisted?
    end

    AtsIdentifiers.save(company_list)
    puts Company.count
  end

  # -----------------------------
  # Jobs
  # -----------------------------

  desc "Import CSV - greenhouse urls"
  task greenhouse: :environment do
    company_list = AtsIdentifiers.load

    jobs_csv = 'storage/new/grnhse_job_posting_urls.csv'

    puts Job.count
    puts "Creating new jobs..."

    CSV.foreach(jobs_csv, headers: true) do |row|
      url = row['posting_url']
      ats, company = Url::CreateJobFromUrl.new(url).create_company_then_job
      company_list[ats.name] << company.ats_identifier if company&.persisted?
    end

    AtsIdentifiers.save(company_list)
    puts Job.count
  end

  # TODO: Complete this task later (required significant additional functionality so paused for now) - NOT FULLY WORKING YET

  desc "Import CSV - job_posting_urls"
  task job_posting_urls: :environment do
    company_list = AtsIdentifiers.load

    jobs_csv = 'storage/new/job_posting_urls.csv'

    puts Job.count
    puts "Creating new jobs..."

    CSV.foreach(jobs_csv, headers: true) do |row|
      url = row['posting_url']
      ats, company = Url::CreateJobFromUrl.new(url).create_company_then_job
      company_list[ats.name] << company.ats_identifier if company&.persisted?
    end

    AtsIdentifiers.save(company_list)
    puts Job.count
  end

  # -----------------------------
  # Users
  # -----------------------------

  desc "Import CSV - Users"
  task users: :environment do
    user_csv = 'storage/csv/sample_users.csv'
    Builders::UserBuilder.new(user_csv).build
    puts User.count
  end
end
