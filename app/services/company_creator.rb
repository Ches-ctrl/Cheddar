class CompanyCreator
  include AtsRouter

  def find_or_create_company
    if ats_system_name
      ats_identifier, job_id = ats_identifier_and_job_id
      [ats_module('CompanyDetails').get_company_details(@url, ats_system, ats_identifier), job_id]
    else
      p "Unable to detect ATS system for URL: #{@url}"
      return nil
    end
  end
end
