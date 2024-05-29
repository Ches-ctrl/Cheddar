namespace :sort_csv do
  desc "Sort CSV - ats_identifiers"
  task sort_ats_identifiers: :environment do
    Csv::SortCsv.new.sort_ats_identifiers
  end

  desc "Sort CSV - company_urls"
  task sort_company_urls: :environment do
    Csv::SortCsv.new.sort_company_urls
  end

  desc "Sort CSV - job_urls"
  task sort_job_urls: :environment do
    Csv::SortCsv.new.sort_job_urls
  end
end
