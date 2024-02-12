module Ats::Pinpointhq::CompanyDetails
  extend ActiveSupport::Concern

  def self.get_company_details(url, ats_system, ats_identifier)
    p "Getting PinpointHQ company details - #{url}"

    company_name = ats_identifier.capitalize
    company = Company.find_by(company_name: company_name)

    if company
      p "Existing company - #{company.company_name}"
    else
      api_url, main_url = replace_ats_identifier(ats_system, ats_identifier)
      p "API URL: #{api_url}"
      p "Main URL: #{main_url}"
      company = Company.create(
        company_name: company_name,
        ats_identifier: ats_identifier,
        applicant_tracking_system_id: ats_system.id,
        url_ats_api: api_url,
        url_ats_main: main_url,
      )

      p "Created company - #{company.company_name}" if company.persisted?

      # p "Calling GetAllJobUrls"
      # GetAllJobUrls.new(company).get_all_job_urls if new_company
      # p "Finished GetAllJobUrls"

      # TODO: Handle logic for GetAllJobUrls via web scrape or API call depending on ATS system
    end
    company
  end

  def self.replace_ats_identifier(ats_system, ats_identifier)
    api_url = ats_system.base_url_api
    main_url = ats_system.base_url_main

    api_url.gsub!("XXX", ats_identifier)
    main_url.gsub!("XXX", ats_identifier)
    [api_url, main_url]
  end
end
