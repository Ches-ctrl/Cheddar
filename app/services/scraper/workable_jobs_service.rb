module Scraper
  class WorkableJobsService < ApplicationService
    include CheckUrlIsValid

    def self.import_jobs
      return p "Unable to import jobs from Workable: first create ATS" unless (@ats = ApplicantTrackingSystem.find_by(name: 'Workable'))

      url = @ats.url_xml
      html = fetch_url(url)
      xml = Nokogiri::HTML.parse(html)
      jobs = xml.xpath('//job')
      jobs.each do |job|
        puts job.xpath('title').text
        puts job.xpath('referencenumber').text
        puts job.xpath('url').text
        puts job.xpath('company').text
        puts job.xpath('website').text
        # 1. Guess the ats_identifier from company name or website domain

        # PATH A:
        # 2. Fetch job data from: "https://apply.workable.com/api/v2/accounts/#{ats_identifier}/jobs/#{job_reference_number}"
        # 3. Change ats_identifier to 'accountUid' in job data

        # PATH B:
        # 2. Create company by ats_identifier
        # 3. Get company data from "https://apply.workable.com/api/v1/accounts/#{ats_identifier}/"
        # 4. Change the company's ats_identifier to the 'uid' listed there.

        # 5. Get all the company's jobs from "https://jobs.workable.com/api/v1/jobs/#{company_uid}"
      end
    end

    private

    private_class_method def self.fetch_url(url)
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'

      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      puts "Response code: #{response.code}"
      response.header.each do |key, value|
        puts "#{key}: #{value}"
      end
      puts "Response body: #{response.body}"
      retry_after = response.header['retry-after']
      puts "Retry-After: #{retry_after}"
      response
    end
  end
end
