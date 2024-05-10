module Xml
  class WorkableService < ApplicationService
    # Docs: https://help.workable.com/hc/en-us/articles/4420464031767-Utilizing-the-XML-Job-Feed
    # To use this:
    # rake xml:workable
    # How this works:
    # NB. the Workable XML feed is sensitive to 403 Forbidden errors (too many requests)
    # The feed includes urls of the format: https://apply.workable.com/j/9A5B371BA0 (i.e. without the ats_identifier)
    # In order to handle this, we create a variable with all the job_posting_urls from the XML feed
    # We then resolve the redirect to get the final url and build the company / job posting from the API via CreateJobFromUrl, this bypasses rate limiting problems and uses standard functionality

    # TODO: Fix this as only capturing a portion of the redirect urls at the moment. There is a wait screen page that is sometimes coming up and it may require a proxy to process. Check for the interim response code. Setup a proxy and use a different IP address to check the page.
    # TODO: Add count for number of urls in XML feed and number of urls processed so that we can evaluate success rate

    # TODO: This can be made more efficient in future as lots of the job_posting_urls will already exist in the database after the first run
    # TODO: What we can do is extract the ats_identifiers from the job_posting_urls and then exclude any for which the company already exists in the DB (as this will have a separate process)

    def import_xml
      return "Unable to import Workable XML: first create ATS" unless (ats = ApplicantTrackingSystem.find_by(name: 'Workable'))

      url = ats.url_xml

      begin
        xml_data = Nokogiri::XML(URI.parse(url).open)
      rescue OpenURI::HTTPError => e
        if e.message.include?('403')
          puts "Error: 403 Forbidden while fetching XML data from #{url}"
        else
          puts "Error: #{e.message} while fetching XML data from #{url}"
        end
        return nil
      rescue StandardError => e
        puts "Error: #{e.message}"
        return nil
      end

      # NB. This file is very large and can take a long time to process
      job_nodes = xml_data.xpath('//job')
      job_urls = job_nodes.map { |job_node| job_node.at_xpath('url')&.text&.strip }.compact

      # The below is for testing the redirect functionality without hitting the XML feed (comment out the above and use this)
      # job_urls = ["https://apply.workable.com/j/9A5B371BA0", "https://apply.workable.com/j/2595A6EDD0", "https://apply.workable.com/j/2DA044E84E", "https://apply.workable.com/j/5ECBE14794", "https://apply.workable.com/j/F44ED9E40A", "https://apply.workable.com/j/0908074E5D", "https://apply.workable.com/j/0AA38013AC", "https://apply.workable.com/j/8D801CE251", "https://apply.workable.com/j/E91B0F3F46", "https://apply.workable.com/j/802966A156"]

      final_job_urls = job_urls.map { |job_url| resolve_redirect(job_url) }.compact

      p "Final job urls: #{final_job_urls}"

      final_job_urls.each do |url|
        Url::CreateJobFromUrl.new(url).create_company_then_job
      end
    end

    def resolve_redirect(url)
      p "Resolving redirect for - #{url}"
      uri = URI.parse(url)
      response = Net::HTTP.get_response(uri)
      # Typical response is: #<Net::HTTPMovedPermanently 301 Moved Permanently readbody=true>

      relative_path = response['location']
      # Typical path is: relative path e.g. /techfirefly/j/F44ED9E40A/

      if response.is_a?(Net::HTTPRedirection) && relative_path.start_with?('/')
        p "Redirected to - #{relative_path}"
        redirect_url = "https://#{uri.host}#{relative_path}/"
      elsif response.is_a?(Net::HTTPRedirection)
        p "Redirected to absolute path - #{relative_path}"
        redirect_url = relative_path
      else
        redirect_url = url
      end
      redirect_url
    end
  end
end
