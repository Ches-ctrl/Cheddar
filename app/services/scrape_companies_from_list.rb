class ScrapeCompaniesFromList
  include CompanyCsv

  def initialize
    puts "Importing companies from list..."
    @urls = load_from_csv('url_list')
    @companies = ats_list
    @no_of_companies = Company.count
    @no_of_jobs = Job.count
  end

  def call
    @urls.each do |url|
      ats, ats_identifier, _job_id = JobUrl.new(url).parse(@companies)
      next puts "couldn't find ats for url: #{url}" unless ats
      next puts "invalid identifier: #{ats_identifier}" unless ats_identifier

      # disable job and company creation to save time
      # next puts "invalid identifier: #{ats_identifier}" unless ats_identifier && (company = ats.find_or_create_company(ats_identifier))

      @companies[ats.name] << ats_identifier
      # puts "unable to create job with: #{url}" unless job_id && ats.find_or_create_job_by_id(company, job_id)
    end

    puts "\nCreated #{Job.count - @no_of_jobs} new jobs with #{Company.count - @no_of_companies} new companies."
    puts "\nStoring the information in CSV format..."
    save_ats_list
  end
end
