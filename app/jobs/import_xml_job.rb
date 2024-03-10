require 'open-uri'

class ImportXmlJob < ApplicationJob
  queue_as :default

  # TODO: At the moment doesn't handle company websites or ATS
  # TODO: Unified data format for all job sources to persist to the database

  def perform
    url = 'https://devitjobs.uk/job_feed.xml'
    xml_data = URI.open(url).read
    doc = Nokogiri::XML(xml_data)

    doc.xpath('//job').take(10).each do |job_xml|
      # limiting to 10 jobs for now

      company_name = job_xml.at('company')&.text
      company = Company.find_or_create_by(company_name:)

      job_attributes = {
        job_title: job_xml.at('title')&.text,
        job_description: job_xml.at('description')&.text,
        job_posting_url: job_xml.at('link')&.text,
        country: job_xml.at('country')&.text,
        location: job_xml.at('location')&.text,
        company_id: company.id,
        employment_type: job_xml.at('jobtype')&.text,
        date_created: Date.parse(job_xml.at('pubdate')&.text)
        # advertiser_type: job_xml.at('AdvertiserType')&.text,
        # is_promoted: job_xml.at('ispromoted')&.text == 'true',
        # cpc: job_xml.at('cpc')&.text.to_d,
        # apply_url: job_xml.at('apply_url')&.text,
        # region: job_xml.at('region')&.text,
        # city: job_xml.at('city')&.text,
        # postal_code: job_xml.at('postal_code')&.text,
        # postcode: job_xml.at('postcode')&.text,
        # logo: job_xml.at('logo')&.text,
        # salary: job_xml.at('salary')&.text,
        # job_status: job_xml.at('job-status')&.text,
      }

      Job.create(job_attributes)

      p Job.last
    end
  end
end
