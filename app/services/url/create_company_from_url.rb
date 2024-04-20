module Url
  class CreateCompanyFromUrl
    include CompanyCsv
    include CheckUrlIsValid

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
      p "ATS - #{ats&.name}"

      return unless ats

      # ---------------
      # Parse URL
      # ---------------

      ats_identifier, job_id = ats.parse_url(@url)
      p "ATS Identifier - #{ats_identifier}"
      p "Job ID - #{job_id}"

      # ---------------
      # CompanyCreator
      # ---------------

      company = ats.find_or_create_company(ats_identifier)
      if company&.persisted?
        puts "Created company - #{company.company_name}"
      else
        puts "Failed to create company from #{@url}"
      end

      return [ats, company, job_id]

      # ---------------
      # SaveToCsv
      # ---------------

      # @companies[ats.name] << ats_identifier
      # puts "unable to create job with: #{url}" unless job_id && ats.find_or_create_job(company, job_id)

      # puts "\nStoring the information in CSV format..."
      # save_ats_list
    end
  end
end
