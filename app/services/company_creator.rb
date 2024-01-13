class CompanyCreator
  include Ats::AtsHandler

  def find_or_create_company
    if ats_system
      ats_module('CompanyDetails').get_company_details(@url)
    else
      p "Unable to detect ATS system for URL: #{@url}"
      return nil
    end
  end
end
