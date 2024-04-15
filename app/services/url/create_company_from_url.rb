module Url
  class CreateCompanyFromUrl
    include CompanyCsv
    include CheckUrlIsValid
    include AtsSystemParser

    def initialize(url)
      @url = url
    end

    def create_company
      # TODO: Fix this. At the moment we have multiple ways of importing companies into the DB. We should just have one format.
      # TODO: Move this into a module or separate service object e.g. CreateCompany or CreateCompanyFromUrl as this is replicated code from CreateJobFromUrl and is the same logic
      # TODO: Not sure how this is meant to work but the refactor killed the ParseJobUrlFromAts class so had to port in other methods here

      # ---------------
      # ATS Router
      # ---------------

      p @url

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

      company = ApplicantTrackingSystem.get_company_details(url, ats, ats_identifier)
      puts "Created company - #{company.company_name}"

      # ---------------
      # SaveToCsv
      # ---------------

      # @companies[ats.name] << ats_identifier
      # puts "unable to create job with: #{url}" unless job_id && ats.find_or_create_job_by_id(company, job_id)

      # puts "\nStoring the information in CSV format..."
      # save_ats_list
    end
  end
end
