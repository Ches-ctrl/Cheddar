class ImportCompaniesFromList
  include CompanyCsv

  # TODO: Delete this as we now have CreateCompanyFromUrl which does the same functionality

  def initialize(urls = load_from_csv('company_url_list'))
    puts "Importing companies from list..."
    @urls = urls
    @companies = ats_list
    @no_of_companies = Company.count
    @no_of_jobs = Job.count

    # NB. Would you usually call methods in the initialiser like this?
  end

  def call
    @urls.each do |url|
      ats, company, job = CreateJobFromUrl.new(url).create_company_then_job
      @companies[ats.name] << company.ats_identifier
      puts "Unable to create job with: #{url}" unless company && job
    end

    puts "\nCreated #{Job.count - @no_of_jobs} new jobs with #{Company.count - @no_of_companies} new companies."
    puts "\nStoring the information in CSV format..."
    save_ats_list
  end
end
