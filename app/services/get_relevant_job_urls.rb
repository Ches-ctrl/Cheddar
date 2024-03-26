class GetRelevantJobUrls
  include Ats::Greenhouse::FetchCompanyJobs

  def initialize(company_array)
    @company_array = company_array
  end

  def fetch_jobs
    jobs = []
    @company_array.each do |company|
      puts "Scanning Greenhouse jobs with #{company}..."
      @ats_identifier = company
      jobs += return_relevant_jobs
    end
    jobs
  end
end
