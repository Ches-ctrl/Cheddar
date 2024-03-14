class ScrapeRelevantJobUrls
  include Ats::Greenhouse::FetchCompanyJobs
  # include Ats::Lever::FetchCompanyJobs
  # include Ats::Workable::FetchCompanyJobs

  def initialize(company_array)
    @company_array = company_array
  end

  def fetch_jobs
    jobs_data = []
    @company_array.each do |company|
      puts "Scanning Greenhouse jobs with #{company}..."
      @ats_identifier = company
      next unless (company_data = greenhouse_jobs_by_relevant_department)

      jobs_data += company_data
    end
    puts "Finished getting jobs.\n"
    puts "Writing to storage..."
    write_to_storage(jobs_data)
  end

  private

  def write_to_storage(data)
    filepath = 'storage/relevant_jobs.csv'
    CSV.open(filepath, "wb") do |csv|
      csv << ['Job Title', 'Job Description', 'Inferred Seniority']
      data.each do |line|
        csv << line
      end
    end
  end
end
