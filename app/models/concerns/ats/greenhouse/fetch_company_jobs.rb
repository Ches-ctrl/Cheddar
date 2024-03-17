module Ats::Greenhouse::FetchCompanyJobs
  extend ActiveSupport::Concern

  DEPARTMENT_KEYWORDS = [
    /engineer/,
    /software/,
    /tech/,
    /platform/,
    /network/,
    /\bdata/,
    /machine learning/,
    /\bml\b/,
    /\bit\b/,
    /information security/,
    /info.?sec/,
    /implementation/,
    /design system/,
    /\bqa\b/,
    /tribe/
  ]

  JOB_TITLE_KEYWORDS = [
    /front-?end/,
    /back-?end/,
    /full-?stack/,
    /software/,
    /technical lead/,
    /development engineer/,
    /deployed.{1,28}engineer/,
    /research engineer/,
    /prompt engineer/,
    /mobile (?:engineer|developer)/,
    /infrastructure (?:engineer|architect)/,
    /platform (?:engineer|developer)/,
    /security engineer/,
    /cloud engineer/,
    /network engineer/,
    /reliability engineer/,
    /\bsre engineer/,
    /support engineer/,
    /escalation engineer/,
    /test automation engineer/,
    /gameplay engineer/,
    /developer/,
    /programmer/,
    /\bui\b/,
    /\bux\b/,
    /\bqa\b/,
    /dev-?ops/,
    /\bios\b/,
    /android/,
    /data scientist/,
    /\bml\b/,
    /\bai\b/,
    /machine learning/,
    /blockchain/,
    /game designer/,
    /cybersecurity/,
    /threat detection/,
    /malware/,
    /\bit\b/,
    /technical designer/,
    /\bseo\b/,
    /ruby/,
    /ruby on rails/,
    /python/,
    /django/,
    /\.net\b/,
    /\bc#/,
    /\bc\+\+/,
    /java/,
    /springboot/,
    /kafka/,
    /distributed systems/,
    /server/,
    /golang/,
    /javascript/,
    /\bjs\b/,
    /nodejs/,
    /\breact\b/,
    /jenkins/,
    /terraform\b/,
    /\bci\/cd\b/,
    /database/,
    /\bsql\b/,
    /workflow automation/,
    /\bapi\b/,
    /cloud platform/,
    /cloud ops/,
    /kubernetes/,
    /\baws\b/,
    /google cloud/,
    /\bgcp\b/,
    /linux/,
    /unix/,
    /\btcp\b/
  ]

  SENIORITY_TITLES = {
    /intern/ => 0,
    /apprentice/ => 1,
    /graduate/ => 1,
    /entry.?level/ => 1,
    /associate/ => 1,
    /\bassoc\b/ => 1,
    /junior/ => 2,
    /\bjr\b/ => 2,
    /early.?career/ => 2,
    /\bi\b/ => 2,
    /\bmid\b/ => 3,
    /mid-?weight/ => 3,
    /mid-?level/ => 3,
    /\bii\b/ => 3,
    /\biii\b/ => 3,
    /senior/ => 4,
    /\bsr\b/ => 4,
    /\blead\b/ => 4,
    /principal/ => 4,
    /staff/ => 4
  }

  LOCATION_KEYWORDS = [
    'london',
    'manchester',
    'leeds',
    'birmingham',
    'liverpool',
    'reading',
    'bristol',
    'brighton',
    'england',
    'united kingdom',
    'uk',
    'britain'
  ]

  # def return_relevant_jobs
  #   data = fetch_company_jobs(@ats_identifier)
  #   relevant_jobs = []
  #   data['jobs'].each do |job|
  #     search_field = job['title'].downcase.split(/[^a-z0-9]/)
  #     relevant_jobs << job['absolute_url'] if JOB_TITLE_KEYWORDS.any? { |keyword| search_field.include?(keyword) }
  #   end
  #   relevant_jobs
  # end

  def self.fetch_seniority_tagged_jobs(ats_identifier)
    @ats_identifier = ats_identifier
    return unless (jobs = fetch_company_jobs)

    jobs&.inject([]) do |jobs_data, job|
      job_id = job['id']
      job_title = job['title'].downcase
      next jobs_data unless (inferred_seniority = infer_seniority_from(job_title))

      next jobs_data unless JOB_TITLE_KEYWORDS.any? { |keyword| job_title.match?(keyword) }

      next jobs_data unless (job_description = fetch_job_description(job_id))

      puts job_title
      jobs_data << [ats_identifier, job_title, job_description, inferred_seniority]
    end
  end

  def self.fetch_company_jobs(ats_identifier)
    company_api_url = "https://boards-api.greenhouse.io/v1/boards/#{ats_identifier}/jobs"
    uri = URI(company_api_url)
    begin
      response = Net::HTTP.get(uri)
    rescue Errno::ECONNRESET => e
      puts "Connection reset by peer: #{e}"
      return
    end
    data = JSON.parse(response)
    return data['jobs']
  end

  def get_job_urls(data)
    return data['jobs'].map { |job| job['absolute_url'] }
  end

  private

  private_class_method def self.clean_up_text(string)
    return unless string

    string.gsub(/(?:&lt|&quot|div ).*?(?:gt);\s*(?=[A-Z*$£€,]|\d(?!\d?&)|\p{Emoji}|$)/, " -- ")
          .gsub(/&quot|&amp|nbsp/, '')
  end

  private_class_method def self.infer_seniority_from(job_title)
    SENIORITY_TITLES.each do |keyword, level|
      return level if job_title.match?(keyword)
    end
    return
  end

  private_class_method def self.fetch_department(job_id)
    job_api_url = "https://boards-api.greenhouse.io/v1/boards/#{@ats_identifier}/jobs/#{job_id}"
    uri = URI(job_api_url)
    begin
      response = Net::HTTP.get(uri)
    rescue Errno::ECONNRESET => e
      puts "Connection reset by peer: #{e}"
      return
    end
    data = JSON.parse(response)
    # fetch just the first department
    department = data['departments'][0]['name'].downcase unless data['departments'].empty?
    description = clean_up_text(data['content'])
    return [department, description]
  end

  private_class_method def self.fetch_job_description(job_id)
    job_api_url = "https://boards-api.greenhouse.io/v1/boards/#{@ats_identifier}/jobs/#{job_id}"
    uri = URI(job_api_url)
    begin
      response = Net::HTTP.get(uri)
    rescue Errno::ECONNRESET => e
      puts "Connection reset by peer: #{e}"
      return
    end
    data = JSON.parse(response)
    # fetch just the first department
    description = clean_up_text(data['content'])
    return description
  end
end
