module Ats::Lever::FetchCompanyJobs
  extend ActiveSupport::Concern

  def fetch_company_jobs(ats_identifier)
    company_api_url = "https://boards-api.greenhouse.io/v1/boards/#{ats_identifier}/jobs"
    company_api_url = "https://api.lever.co/v0/postings/#{ats_identifier}?mode=json"
    uri = URI(company_api_url)
    begin
      response = Net::HTTP.get(uri)
    rescue Errno::ECONNRESET => e
      puts "Connection reset by peer: #{e}"
      return
    end
    return JSON.parse(response)
  end
end
