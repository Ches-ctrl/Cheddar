namespace :sort_csv do
  desc "Sort CSV - ats_identifiers"
  task sort_ats_identifiers: :environment do
    Csv::SortCsv.new.sort_ats_identifiers
  end

  desc "Sort CSV - company_urls"
  task sort_company_url_list: :environment do
    Csv::SortCsv.new.sort_company_urls
  end

  desc "Sort CSV - job_posting_urls"
  task sort_job_postings: :environment do
    csv = CSV.read('storage/new/job_posting_urls.csv', headers: true)
    sorted = csv.sort_by { |row| row['posting_url'] }

    CSV.open('storage/new/job_posting_urls.csv', 'w') do |csv|
      csv << ['posting_url']
      sorted.each { |row| csv << [row['posting_url']] }
    end
  end
end
