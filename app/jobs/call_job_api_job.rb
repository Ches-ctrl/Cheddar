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

# p job
# p job.job_title
# p job.job_description
# p job.job_posting_url
# p job.employment_type
# p job.location
# p job.country
# p job.industry
# p job.seniority
# p job.applicants_count
# p job.company_id
# p job.cheddar_applicants_count

# ---------------------
# CoreSignal API Request Response:
# ---------------------
#
# {"id":203860680,
# "created":"2023-11-14 13:58:36",
# "last_updated":"2023-12-01 04:52:03",
# "time_posted":"2 weeks ago",
# "title":"Junior Full Stack Developer .Net Core",
# "description":
# "Apidura\nBuilt from a passion for adventure, cycling and the outdoors, Apidura produces ultralight equipment to enable cyclists to travel farther, faster and more comfortably. Our relentless commitment to producing high quality, thoughtfully designed products has made Apidura the leading choice in lightweight cycling packs.\n\nApidura is looking for a highly motivated Junior Full stack developer .net core 6.0 C#, SQL, Restful API, WebApp to join its London team. This position reports directly to the Technical Lead and requires an experienced candidate with the skills and desire to develop themselves as a key part of the digital team in this fast-paced, digitally native adventure sports brand. An outstanding ability to multitask, be flexible in approach and the capacity to take on a range of responsibilities are key.\n\nResponsibilities\n• Design, develop and maintain software applications and UI using C#, .net core 6.\n• Ensure the best possible performance, reliability, and quality of our internal tools/Api.\n• Collaborate on solutions designs and related code.\n• Participate in the software development life cycle from planning to deployment.\n• Write clean, maintainable code.\n• Troubleshoot and resolve technical issues.\n• Implement and maintain security measures.\n• Develop new functionalities.\n• Implement good UI/UX based on needs.\n• Growing your skills and provide your insight of improvement/optimization.\n• Communicate with the team to understand the needs\n\n\nExperience\n• Proven experience and knowledge C#, .net core 6 of 2/3 years, we will consider just graduated profiles as well.\n• Understanding of dependency injection\n• Experienced with Microsoft .NET technology stack: C# / .NET, .NET Core, ASP.Net, Web APIs.\n• Experience with code management tools like Git.\n• JavaScript, jQuery, SCSS/CSS, HTML.\n• Understanding of SQL language, stored procedure\n• Familiarity with RESTful APIs and modern authorization mechanisms such as JSON Web Token.\n• Security understanding\n• Strong problem-solving skills and attention to detail.\n• Motivated, willing to learn/improve/optimize code and perseverant.\n• Good communication skills and ability to speak of technical concept/solution to a non-technical person.\n\n\n Essential Skills\n• Excellent attention to detail with a thorough approach to your work.\n• Strong organisation, time management and documentation habits.\n• Proactive in approach and a strong advocate for continuous improvement.\n• A desire to understand the wider context, and impact of your work on the business and its systems.\n• Open to both learning and sharing knowledge and exploring new technologies.\n• Comfortable in communicating to non-technical persons and used to simplifying IT language without losing meaning.\n• Ability to work within a team and translate requirements into technical solutions.\n• Strike a balance between working with autonomy vs. seeking support when tackling new tasks.\n\n\nAdditional requirements\n• Interest, energy and flexibility to work in the fast-paced environment of a growing business and wear multiple hats.\n• Keen interest in cycling is a bonus.\n• Candidate must be authorized to work in the UK.\n\n\nWhat We Offer\n• Financial support for your bike packing and racing adventures\n• Access to our Gear Library which includes tents, clothing and outdoor equipment for any trips\n• Extensive industry discounts\n• Flexible Wednesday mornings for bike riding or other sports and wellness activities\n• Role-specific hybrid working arrangements\n• Monthly socials and activities\n• Professional development with access to courses and further education\n• Opportunities to work from our Annecy office\n\n\nApidura is committed to operating in a fair and socially responsible manner, this includes our stance on ensuring diversity, equity and inclusion, both in cycling and in the workplace. Apidura is an accredited Living Wage Employer, a member of the Better Business Act Coalition and a certified B Corp.",
# "seniority":"Entry level",
# "employment_type":"Full-time",
# "location":"London, England, United Kingdom",
# "url":"https://www.linkedin.com/jobs/view/junior-full-stack-developer-net-core-at-apidura-3764916792",
# "hash":"22d498557440a62dce99b98539c6b94a",
# "company_id":8698409,
# "company_name":"Apidura",
# "company_url":"https://www.linkedin.com/company/apidura",
# "external_url":"https://www.apidura.com/junior-hybrid-full-stack-developer-net-core-6-c/",
# "deleted":0,"application_active":0,
# "salary":null,
# "applicants_count":"Over 200 applicants",
# "linkedin_job_id":3764916792,"country":"United Kingdom",
# "redirected_url":"https://www.linkedin.com/jobs/view/junior-full-stack-developer-net-core-at-apidura-3764916792",
# "job_industry_collection":[{"job_industry_list":{"industry":"Retail"}}]}
