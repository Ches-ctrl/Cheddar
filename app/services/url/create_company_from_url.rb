module Url
  class CreateCompanyFromUrl
    include CompanyCsv
    include CheckUrlIsValid
    include AtsSystemParser

    def initialize(url)
      @url = url
    end

    def create_company
      # TODO: This needs to be refactored as it is currently not DRY - both CreateJobFromUrl and CreateCompanyFromUrl have the same logic
      # TODO: Refactor this into a CsvController?
      # TODO: Fix SaveToCsv

      # ---------------
      # ATS Router
      # ---------------

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
