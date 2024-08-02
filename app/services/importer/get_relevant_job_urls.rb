module Importer
  # This is a helper class that's called from the seedfile. Its purpose is to receive a list of ats_identifiers and return a list of posting urls for relevant jobs to seed.
  # It calls three applicant_tracking_system methods:
  #   - #fetch_company_jobs makes a single api call and returns the all_jobs json
  #   - #fetch_title_and_location extracts from the all_jobs json the two arguments required by #relevant?
  #   - #fetch_posting_url builds or extracts the posting_url, which is added to the array that's ultimately returned

  class GetRelevantJobUrls
    include Relevant

    def initialize(ats, company_array)
      @ats = ats
      @ats_name = @ats.name
      @company_array = company_array
    end

    def fetch_jobs
      jobs = []
      @company_array.each do |company|
        puts "Scanning #{@ats_name} jobs with #{company}..."
        @ats_identifier = company
        jobs += return_relevant_jobs
      end
      jobs
    end

    private

    def return_relevant_jobs
      data = @ats.fetch_company_jobs(@ats_identifier)
      relevant_jobs = []
      data&.each do |job_data|
        title, location = @ats.fetch_title_and_location(job_data)
        relevant_jobs << @ats.fetch_posting_url(job_data, *ats_specific_args) if relevant?(title, location)
      end
      relevant_jobs
    end

    def ats_specific_args
      # Additional parameters required to build the posting_url with some ATS
      [@ats_identifier] if @ats_name == 'BambooHR'
    end
  end
end
