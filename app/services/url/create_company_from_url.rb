class CreateCompanyFromUrl
  include CompanyCsv
  include CheckUrlIsValid
  include AtsSystemParser

  def initialize
    puts "Importing companies from CSV list..."
    @company_urls = load_from_csv('other_company_urls')
    @companies = ats_list
    @no_of_companies = Company.count
    @no_of_jobs = Job.count
  end

  def call
    @company_urls.each do |url|
      p "URL - #{url}"
      # TODO: Fix this. At the moment we have multiple ways of importing companies into the DB. We should just have one format.
      # TODO: Move this into a module or separate service object e.g. CreateCompany or CreateCompanyFromUrl as this is replicated code from CreateJobFromUrl and is the same logic

      ats = ApplicantTrackingSystem.determine_ats(@url)
      p "ATS - #{ats.name}"

      # ---------------
      # Parse URL
      # ---------------

      ats_identifier, job_id = ApplicantTrackingSystem.parse_url(ats, @url)
      p "ATS Identifier - #{ats_identifier}"
      p "Job ID - #{job_id}"

      # ---------------
      # CompanyCreator
      # ---------------

      company = ApplicantTrackingSystem.get_company_details(@url, ats, ats_identifier)
      puts "Created company - #{company.company_name}"

      # disable job and company creation to save time
      # next puts "invalid identifier: #{ats_identifier}" unless ats_identifier && (company = ats.find_or_create_company(ats_identifier))

      # @companies[ats.name] << ats_identifier
      # puts "unable to create job with: #{url}" unless job_id && ats.find_or_create_job_by_id(company, job_id)
    end

    puts "\nCreated #{Job.count - @no_of_jobs} new jobs with #{Company.count - @no_of_companies} new companies."
    puts "\nStoring the information in CSV format..."
    save_ats_list
  end
end
