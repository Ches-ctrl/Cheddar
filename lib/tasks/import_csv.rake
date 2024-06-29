namespace :import_csv do
  desc "Import CSV - ATSs"
  task applicant_tracking_systems: :environment do
    Builders::AtsBuilder.new.build
  end

  desc "Import CSV - Users"
  task users: :environment do
    Builders::UserBuilder.new.build
  end

  desc "Import CSV - company_urls"
  task company_urls: :environment do
    Csv::ImportCompanyUrls.new.import
  end

  desc "Import CSV - greenhouse urls"
  task greenhouse: :environment do
    Csv::ImportGreenhouseUrls.new.import
  end

  # TODO: Complete this task later (required significant additional functionality so paused for now) - NOT FULLY WORKING YET
  desc "Import CSV - job_posting_urls"
  task job_posting_urls: :environment do
    Csv::ImportJobPostingUrls.new.import
  end
end
