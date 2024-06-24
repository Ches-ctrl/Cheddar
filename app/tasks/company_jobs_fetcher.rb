class CompanyJobsFetcher
  include Relevant

  def initialize(company)
    @jobs_found_or_created = []
    @company = company
    @ats = company.applicant_tracking_system
  end

  def call
    return false unless processable
    return jobs_from_subsidiaries if subsidiaries?

    process
  end

  def processable
    @company.ats_identifier.present?
  end

  def process
    fetch_api_data
    create_all_relevant_jobs

    puts "Found or created #{@jobs_found_or_created.size} new jobs with #{@company.name}."
    @jobs_found_or_created
  end

  private

  def create_all_relevant_jobs
    @all_jobs.each do |job_data|
      @job_data = job_data
      create_job if job_relevant?
    end
  end

  def create_job
    # create jobs with data from ATS company endpoint unless individual job endpoint exists:
    if @ats.individual_job_endpoint_exists?
      job_id = @ats.fetch_id(@job_data)
      job = @ats.find_or_create_job(@company, job_id)
    else
      job = @ats.find_or_create_job_by_data(@company, @job_data)
    end
    @jobs_found_or_created << job if job&.persisted?
  end

  def fetch_api_data
    @all_jobs = @ats.fetch_company_jobs(@company.ats_identifier)
    raise Errors::NoDataReturnedError, "The API returned no jobs data for #{@company.name}" unless @all_jobs
  end

  def job_relevant?
    details = @ats.fetch_title_and_location(@job_data)
    relevant?(*details)
  end

  def jobs_from_subsidiaries
    @subsidiaries.inject([]) { |jobs_array, company| jobs_array + CompanyJobsFetcher.new(company).call }
  end

  def subsidiaries?
    return false unless @ats.name == 'Workday'

    @subsidiaries = @ats.fetch_subsidiaries(@company)
    @subsidiaries.present?
  end
end
