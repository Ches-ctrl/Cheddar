# rubocop:disable Metrics/BlockLength
LIST_FILEPATH = Rails.root.join('storage', 'csv', 'ats_identifiers.csv')

# TODO: Move this into a collective CsvService that houses all logic

class AtsIdentifiers
  def self.load
    company_list = Hash.new { |hash, key| hash[key] = Set.new }

    CSV.foreach(LIST_FILEPATH) do |ats_name, ats_identifier|
      company_list[ats_name] << ats_identifier
    end
    company_list
  end

  def self.save(fulllist)
    CSV.open(LIST_FILEPATH, 'wb') do |csv|
      fulllist.each do |ats_name, ats_list|
        ats_list.each do |ats_id|
          csv << [ats_name, ats_id]
        end
      end
    end
  end
end

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

  desc "Import CSV - other_company_urls"
  task other_company_urls: :environment do
    company_list = AtsIdentifiers.load

    company_csv = 'storage/csv/other_company_urls.csv'

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

  desc "Import CSV - greenhouse"
  task greenhouse: :environment do
    company_list = AtsIdentifiers.load

    jobs_csv = 'storage/csv/greenhouse_urls.csv'

    puts Job.count
    puts "Creating new jobs..."

    CSV.foreach(jobs_csv, headers: true) do |row|
      url = row['job_posting_url']
      ats, company = Url::CreateJobFromUrl.new(url).create_company_then_job
      company_list[ats.name] << company.ats_identifier if company&.persisted?
    end

    AtsIdentifiers.save(company_list)
    puts Job.count
  end

  desc "Import CSV - other_ats"
  task other_ats: :environment do
    company_list = AtsIdentifiers.load

    jobs_csv = 'storage/csv/other_ats_urls.csv'

    # TODO: fix manatal as the API endpoint isn't yet working

    puts Job.count
    puts "Creating new jobs..."

    CSV.foreach(jobs_csv, headers: true) do |row|
      url = row['job_posting_url']
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

    jobs_csv = 'storage/csv/job_posting_urls.csv'

    puts Job.count
    puts "Creating new jobs..."

    CSV.foreach(jobs_csv, headers: true) do |row|
      url = row['job_posting_url']
      ats, company = Url::CreateJobFromUrl.new(url).create_company_then_job
      company_list[ats.name] << company.ats_identifier if company&.persisted?
    end

    AtsIdentifiers.save(company_list)
    puts Job.count
  end

  desc "Check number of jobs by ATS"
  task number_of_jobs: :environment do
    # TODO: Very basic implementation at the moment - needs to handle jobs boards, company sites, non-valid urls etc.

    ats_jobs_count = Hash.new(0)

    files = [
      '80k_job_posting_urls.csv',
      'BN_job_posting_urls.csv',
      'CO_job_posting_urls.csv',
      'GH_job_posting_urls.csv',
      'LU_job_posting_urls.csv',
      'PA1_job_posting_urls.csv',
      'PA2_job_posting_urls.csv',
      'UM_job_posting_urls.csv'
    ]

    counter = 0

    files.each do |file|
      CSV.foreach("storage/new/#{file}", headers: true) do |row|
        counter += 1
        begin
          url = row['job_posting_url']
          p url
          ats = ApplicantTrackingSystem.determine_ats(url).name if url
          ats_jobs_count[ats] += 1 if ats
        rescue StandardError => e
          puts "Error occurred: #{e.message}"
          next
        end
      end
    end

    sorted_ats_jobs_count = ats_jobs_count.sort_by { |_ats, count| -count }

    CSV.open('storage/csv/no_of_jobs_by_ats.csv', 'w') do |csv|
      csv << ['ATS', 'Number of Jobs']
      csv << ['Total', counter]
      sorted_ats_jobs_count.each do |ats, count|
        csv << [ats, count]
      end
    end

    puts "Total number of jobs: #{ats_jobs_count.values.sum}"
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
# rubocop:enable Metrics/BlockLength
