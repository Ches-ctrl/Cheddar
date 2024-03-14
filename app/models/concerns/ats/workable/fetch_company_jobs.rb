module Ats::Workable::FetchCompanyJobs
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
    'software',
    'engineer',
    'developer',
    'programmer',
    'ui',
    'ux',
    'qa',
    'data scientist',
    'ml',
    'machine learning',
    'game designer',
    'cybersecurity',
    'it',
    'technical designer',
    'seo'
  ]

  SENIORITY_TITLES = {
    /intern/ => 0,
    /graduate/ => 1,
    /entry.?level/ => 1,
    /associate/ => 1,
    /junior/ => 2,
    /early.?career/ => 2,
    /\bi\b/ => 2,
    /\bmid\b/ => 3,
    /mid-?weight/ => 3,
    /mid-?level/ => 3,
    /\bii\b/ => 3,
    /\biii\b/ => 3,
    /senior/ => 4,
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

  def return_relevant_jobs
    data = fetch_company_jobs(@ats_identifier)
    relevant_jobs = []
    data['jobs'].each do |job|
      search_field = job['title'].downcase.split(/[^a-z0-9]/)
      relevant_jobs << job['absolute_url'] if JOB_TITLE_KEYWORDS.any? { |keyword| search_field.include?(keyword) }
    end
    relevant_jobs
  end

  def greenhouse_jobs_by_relevant_department
    jobs_data = []
    false_negatives = []
    return unless (data = fetch_company_jobs(@ats_identifier))

    data['jobs'].each do |job|
      job_id = job['id']
      job_title = job['title'].downcase
      next unless (inferred_seniority = infer_seniority_from(job_title))

      next unless (department, job_description = fetch_department(job_id))

      if DEPARTMENT_KEYWORDS.any? { |keyword| department.match?(keyword) }
        jobs_data << [job_title, job_description, inferred_seniority]
      else
        title_fields = job_title.split(/[^a-z0-9]/)
        false_negatives << [department, job_title] if JOB_TITLE_KEYWORDS.any? { |keyword| title_fields.include?(keyword) }
      end
    end

    puts "\nHere are the false negatives:" unless false_negatives.empty?
    false_negatives.each do |department, job_title|
      puts "  #{job_title}: #{department}"
    end
    jobs_data
  end

  def fetch_company_jobs(ats_identifier)
    company_api_url = "https://apply.workable.com/api/v1/widget/accounts/#{ats_identifier}"
    uri = URI(company_api_url)
    begin
      response = Net::HTTP.get(uri)
    rescue Errno::ECONNRESET => e
      puts "Connection reset by peer: #{e}"
      return
    end
    return JSON.parse(response)
  end

  def get_job_urls(data)
    return data['jobs'].map { |job| job['absolute_url'] }
  end

  private

  def clean_up_text(string)
    return unless string

    return string.gsub(/(?:&lt|div ).*?;\s*(?=[A-Z*$£€,]|\d(?!\d?&)|$)/, " -- ")
  end

  def infer_seniority_from(job_title)
    SENIORITY_TITLES.each do |keyword, level|
      return level if job_title.match?(keyword)
    end
    return
  end

  def fetch_department(job_id)
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
end
