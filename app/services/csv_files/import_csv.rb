module CsvFiles
  class ImportCsv
    def import_company_urls
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

    def import_greenhouse_urls
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

    def import_job_posting_urls
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
  end
end
