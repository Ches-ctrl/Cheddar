require "uri"
require "json"
require "net/http"

# TODO: Add error handling and surface error to user/admin
# TODO: Wrap in transaction so the method can be rolled back
# TODO: Add Rails.logger to log errors
# TODO: Add ability to handle multiple apis
# TODO: Add ability to handle multiple company names with slight variations
# TODO: Add ability to handle multiple requests based on job title, location and characteristics
# TODO: Add this to admin panel so you can run it manually
# TODO: Setup a cron job to run this every 24 hours

class CallJobApiJob < ApplicationJob
  # TODO: change queue_as to deprioritised relative to job applications
  queue_as :default

  def perform(*_args)
    url = URI("https://api.coresignal.com/cdapi/v1/linkedin/job/search/filter")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    data = collect_job_ids(https, url)

    data.first(5).each do |job_id|
      job_data = collect_job_details(https, job_id)
      company_id = create_company(job_data)
      create_job(company_id, job_data)
      p "completed"
    end
  end

  private

  # "(Full Stack Developer) OR (Full Stack Software Engineer) OR (Full Stack Web Developer)"

  TITLES_DEV = "(Full Stack Developer) OR (Web Developer) OR (Full Stack Web Developer) OR (Graduate Developer)"
  TITLES_ENG = "(Full Stack Software Engineer) OR (Software Engineer) OR (Software Developer) OR (Graduate Software Engineer) OR (Junior Software Engineer)"
  TITLES_CON = "(Consultant) OR (Associate Consultant) OR (Junior Consultant) OR (Graduate Consultant)"

  def collect_job_ids(https, url)
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{ENV.fetch('CORESIGNAL_API_KEY', nil)}"
    request.body = JSON.dump(
      { title: "(Consultant) OR (Associate Consultant) OR (Junior Consultant) OR (Graduate Consultant)",
        application_active: true, deleted: false, country: "(United Kingdom)", location: "London" }
    )

    response = https.request(request)
    JSON.parse(response.body)
  end

  def collect_job_details(https, job_id)
    details_url = URI("https://api.coresignal.com/cdapi/v1/linkedin/job/collect/#{job_id}")
    details_request = Net::HTTP::Get.new(details_url)
    details_request["Content-Type"] = "application/json"
    details_request["Authorization"] = "Bearer #{ENV.fetch('CORESIGNAL_API_KEY', nil)}"

    details_response = https.request(details_request)
    JSON.parse(details_response.body)
  end

  def create_company(job_data)
    existing_company = Company.find_by(company_name: job_data["company_name"])

    # TODO: Remove additional parts of URL before saving to DB

    if existing_company.nil?
      company = Company.new(
        company_name: job_data["company_name"],
        company_website_url: job_data["company_url"],
        location: job_data["location"],
        industry: job_data["job_industry_collection"].first["job_industry_list"]["industry"]
      )

      if company.save!
        puts "Company #{company.company_name} created successfully."
        return company.id
      else
        puts "Company creation failed."
      end
    else
      puts "A Company with the same external_url already exists."
      return Company.find_by(company_name: job_data["company_name"]).id
    end
  end

  def create_job(company_id, job_data)
    if job_data["external_url"].nil?
      # TODO: If job url is from linkedin, go to linkedin and get the actual job posting url
      # TODO: Create linkedin scrape account
      job_url = job_data["url"]
      # if job_data["external_url"].include?("linkedin")
      #   get_job_url(job_data)
      # end
    else
      job_url = job_data["external_url"]
    end

    existing_job = Job.find_by(job_posting_url: job_url)

    if existing_job.nil?
      job = Job.new(
        job_title: job_data["title"],
        job_description: job_data["description"], # TODO: handle \n in job descriptions
        job_posting_url: job_url,
        employment_type: job_data["employment_type"],
        location: job_data["location"],
        country: job_data["country"],
        industry: job_data["job_industry_collection"].first["job_industry_list"]["industry"],
        seniority: job_data["seniority"],
        applicants_count: job_data["applicants_count"],
        company_id:,
        cheddar_applicants_count: 0
      )

      # TODO: Add image to job from clearbit

      if job.save!
        puts "Job #{job.job_title} created successfully."
      else
        puts "Job creation failed."
      end
    else
      puts "A job with the same external_url already exists."
    end
  end

  def get_job_url(job_data)
    # TODO: Go to linkedin and get the actual job posting url
  end

  def get_job_details(job_data)
    # TODO: get job details from job posting url
  end

  def get_application_criteria(job_data)
    # TODO: Add application criteria to job
  end
end
