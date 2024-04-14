class ImportCompaniesFromCsv
  include CompanyCsv

  # TODO: Move to rake task similar to other CSV import functions

  def initialize
    puts "Importing companies from CSV list..."
    @company_urls = load_from_csv('company_urls')
    @companies = ats_list
    @no_of_companies = Company.count
    @no_of_jobs = Job.count
  end

  def call
    @company_urls.each do |url|
      # TODO: Fix this. At the moment we have multiple ways of importing companies into the DB. We should just have one format.
      ats, ats_identifier, job_id = ParseJobUrlByAts.new(url).parse(@companies)
      next puts "couldn't find ats for url: #{url}" unless ats
      next puts "invalid identifier: #{ats_identifier}" unless ats_identifier

      # disable job and company creation to save time
      next puts "invalid identifier: #{ats_identifier}" unless ats_identifier && (company = ats.find_or_create_company(ats_identifier))

      @companies[ats.name] << ats_identifier
      puts "unable to create job with: #{url}" unless job_id && ats.find_or_create_job_by_id(company, job_id)
    end

    puts "\nCreated #{Job.count - @no_of_jobs} new jobs with #{Company.count - @no_of_companies} new companies."
    puts "\nStoring the information in CSV format..."
    save_ats_list
  end
end
