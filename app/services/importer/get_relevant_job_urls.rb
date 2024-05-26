module Importer
  class GetRelevantJobUrls
    include Constants

    # TODO: Remove this as only called in the seed file - should be able to use the overall Relevant service object instead

    def initialize(company_array)
      @company_array = company_array
      @ats = ApplicantTrackingSystem.find_by(name: 'Greenhouse')
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

    def return_relevant_jobs
      data = @ats.fetch_company_jobs(@ats_identifier)
      relevant_jobs = []
      data&.each do |job|
        relevant_jobs << job['absolute_url'] if JOB_TITLE_KEYWORDS.any? { |keyword| job['title'].downcase.match?(keyword) }
      end
      relevant_jobs
    end
  end
end
