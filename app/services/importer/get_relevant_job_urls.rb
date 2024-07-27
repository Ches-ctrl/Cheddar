module Importer
  class GetRelevantJobUrls
    include Relevant

    # TODO: Remove this as only called in the seed file - should be able to use the overall Relevant service object instead

    def initialize(ats, company_array)
      @ats = ats
      @company_array = company_array
    end

    def fetch_jobs
      jobs = []
      @company_array.each do |company|
        puts "Scanning #{@ats.name} jobs with #{company}..."
        @ats_identifier = company
        jobs += return_relevant_jobs
      end
      jobs
    end

    def return_relevant_jobs
      data = @ats.fetch_company_jobs(@ats_identifier)
      relevant_jobs = []
      data&.each do |job|
        title, location = @ats.fetch_title_and_location(job)
        relevant_jobs << @ats.fetch_url(job) if relevant?(title, location)
      end
      relevant_jobs
    end
  end
end
