require "uri"
require "json"
require "net/http"

# TODO: Add error handling and surface error to user/admin
# TODO: Add ability to handle multiple apis
# TODO: Add ability to handle multiple company names with slight variations
# TODO: Add this to admin panel so you can run it manually
# TODO: Setup a cron job to run this every 24 hours

class CallJobApiJob < ApplicationJob
  # TODO: change queue_as to deprioritised relative to job applications
  queue_as :default

  def perform(*args)
    url = URI("https://api.coresignal.com/cdapi/v1/linkedin/job/search/filter")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    data = collect_job_ids(https, url)

    data.each do |job_id|
      job_data = collect_job_details(https, job_id)
      company_id = create_company(job_data)
      create_job(company_id, job_data)
      p "completed"
    end
  end

  private

  def collect_job_ids(https, url)
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{ENV['CORESIGNAL_API_KEY']}"
    request.body = JSON.dump(
      {"title":"(Full Stack Developer) OR (Full Stack Software Engineer) OR (Full Stack Web Developer)","application_active":false,"deleted":false,"country":"(United Kingdom)","location":"London"}
    )

    response = https.request(request)
    data = JSON.parse(response.body)
  end

  def collect_job_details(https, job_id)
    details_url = URI("https://api.coresignal.com/cdapi/v1/linkedin/job/collect/#{job_id}")
    details_request = Net::HTTP::Get.new(details_url)
    details_request["Content-Type"] = "application/json"
    details_request["Authorization"] = "Bearer #{ENV['CORESIGNAL_API_KEY']}"

    details_response = https.request(details_request)
    job_data = JSON.parse(details_response.body)
  end

  def create_company(job_data)
    existing_company = Company.find_by(company_name: job_data["company_name"])

    if existing_company.nil?
      company = Company.new(
        company_name: job_data["company_name"],
        company_website_url: job_data["company_url"],
        location: job_data["location"],
        industry: job_data["job_industry_collection"].first["job_industry_list"]["industry"],
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
        company_id: company_id,
        cheddar_applicants_count: 0,
      )

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
  end

  def get_application_criteria(job_data)
  end
end


# ---------------------
# Job Schema:
# ---------------------
#
# create_table "jobs", force: :cascade do |t|
#   t.string "job_title"
#   t.string "job_description", default: "n/a"
#   t.integer "salary"
#   t.date "date_created"
#   t.text "application_criteria"
#   t.date "application_deadline", default: "2023-12-08"
#   t.string "job_posting_url"
#   t.bigint "company_id", null: false
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
#   t.integer "applicant_tracking_system_id"
#   t.integer "ats_format_id"
#   t.text "application_details"
#   t.text "description_long"
#   t.text "responsibilities"
#   t.text "requirements"
#   t.text "benefits"
#   t.text "application_process"
#   t.boolean "captcha"
#   t.string "employment_type"
#   t.string "location"
#   t.string "country"
#   t.string "industry"
#   t.string "seniority"
#   t.integer "applicants_count"
#   t.integer "cheddar_applicants_count"
#   t.index ["company_id"], name: "index_jobs_on_company_id"
# end


# ---------------------
# Coresignal Job Search Schema:
# ---------------------
# {
#   "created_at_gte": "string",
#   "created_at_lte": "string",
#   "last_updated_gte": "string",
#   "last_updated_lte": "string",
#   "title": "string",
#   "keyword_description": "string",
#   "employment_type": "string",
#   "location": "string",
#   "company_id": 0,
#   "company_name": "string",
#   "company_domain": "string",
#   "company_exact_website": "string",
#   "company_professional_network_url": "string",
#   "deleted": true,
#   "application_active": true,
#   "country": "string",
#   "industry": "string"
# }


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


# ---------------------
# CoreSignal API Request Response II:
# ---------------------
#
# {"id":191967799,"created":"2023-10-14 07:11:58","last_updated":"2023-12-14 04:59:41","time_posted":"2 months ago","title":"Senior Sustainability & Energy Consultant – Strategy","description":"Click here to apply: Job Openings (peoplehr.net)\n\nSENIOR STRATEGY CONSULTANT\n\nLongevity Partners is a multi-disciplinary energy and sustainability consultancy and investment business. Established in 2015 to support the transition to a low carbon economy in the UK, Europe and worldwide, we have since grown to a multi-million leading advisory firm with offices in London, Paris, Amsterdam, Munich, New York, Austin and San Francisco.\n\nOur clients are among the world’s largest real estate investors, leaders in their sectors and seeking excellence in carbon neutrality. Longevity Partners assists its clients with European and global portfolios with services ranging from ESG Strategy definition, assistance and advisory in international reporting, green building certification and large-scale carbon reduction implementation.\n\nThe company is recruiting an ambitious Sustainability Strategy Consultant who can take a client through the journey from strategy creation to implementation, through well-crafted goals, action plans and stakeholder engagement. The role will involve overseeing and working on sustainability reporting for clients, analysing data to identify opportunities for improvement and providing advice and support to help clients deliver on their ambitious sustainability strategies. This role is expected to project manage several clients. This position is based principally in our office in London, UK.\n\nTHE SENIOR STRATEGY ANALYST/ CONSULTANT IS RESPONSIBLE FOR\n\n• Developing a sustainability strategy from scratch, from setting vision statements to performing materiality reviews. \n• Understanding clients’ sustainability impacts and carbon footprints, to advise on setting and delivering on ambitious carbon reduction and broader sustainability targets \n• Helping clients in the delivery of projects from compliance, setting targets to delivering on ambitious goals such as Net Zero or Science-Based Targets \n• Being able to provide insights, future trends, and articulate the value of sustainability to businesses, with an understanding of future value creation. \n• Creating thought leadership pieces for communication, enhancing client offerings, and ensuring the team remains at the forefront of emerging thinking. \n• Building a strong working relationship with client sustainability teams through the provision of accurate and timely advice and deliverables. \n• Developing client relationships and the effective delivery of sustainability services on time and on budget. \n• Supporting the business development of our ESG services to a range of listed investors and corporate client base. \n• Working in a rigorous manner to deliver accurate, high quality, engaging and client-ready outputs. \n• Support the professional development of others within the team.\n\n\nTHE SUCCESSFUL INDIVIDUAL WILL HAVE\n\n• Relevant degree and/or master’s degree or equivalent 3-5 years work experience \n• Experience in strategy planning, building business cases, and demonstrating the value of sustainability and the business imperative for tackling climate change \n• Strong analytical skills, with an ability to manage and interpret data to inform effective decision making \n• Experience in initiatives such as CDP, GRESB, Science-Based Targets, Net Positive approaches are desirable \n• Proven project management experience and excellent communication skills \n• Attention to detail and accuracy in written, visual and numeric work \n• Personable character with an ability to foster good working relationships and good experience of leading individuals or small teams \n• Ability to obtain buy-in and engagement from employees at all levels \n• Experience liaising with, engaging and presenting to senior business leaders \n• Good awareness of a broad range of corporate social and environmental sustainability programs, including areas such as Science Based Targets and Net Positive goals \n• Passionate about tackling climate change and promoting the broader sustainability agenda","seniority":"Mid-Senior level","employment_type":"Full-time","location":"London, England, United Kingdom","url":"https://www.linkedin.com/jobs/view/senior-sustainability-energy-consultant-%25E2%2580%2593-strategy-at-longevity-partners-3733094971","hash":"45b5bba589457ac264731a9d3cf993c7","company_id":8544524,"company_name":"Longevity Partners","company_url":"https://www.linkedin.com/company/longevity-partners","external_url":"https://longevity-partners.com/careers/senior-sustainability-energy-consultant-strategy/","deleted":0,"application_active":0,"salary":null,"applicants_count":"Be among the first 25 applicants","linkedin_job_id":3733094971,"country":"United Kingdom","redirected_url":"https://www.linkedin.com/jobs/view/senior-sustainability-energy-consultant-%25E2%2580%2593-strategy-at-longevity-partners-3733094971","job_industry_collection":[{"job_industry_list":{"industry":"Environmental Services"}}]}
