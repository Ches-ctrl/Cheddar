require "uri"
require "json"
require "net/http"

# NB. Not yet tested to be working

# TODO: Test API Request
# TODO: Add error handling
# TODO: Add logging
# TODO: Add fields to job table
# TODO: Save data to job table
# TODO: Create company if company doesn't exist
# TODO: Create industry table
# TODO: Evaluate Job vs Service and implications on application performance

class JobApiService
  def fetch_and_save_jobs
    url = URI("https://api.coresignal.com/cdapi/v1/linkedin/job/search/filter")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{ENV['CORESIGNAL_API_KEY']}"
    request.body = JSON.dump(
    {"title":"(Full Stack Developer) OR (Full Stack Software Engineer) OR (Full Stack Web Developer)","application_active":false,"deleted":false,"country":"(United Kingdom)","location":"London"}
    )

    response = https.request(request)
    puts response.read_body

    # Parsing the data into json and calling the method to output the jobs
    data = JSON.parse(response.body)
    create_job_from_api_data(data)
  end

  private

  def create_job_from_api_data(data)
    # Check if data already exists in the database (via unique identifier e.g. external_url)
    return if Job.exists?(external_url: data["external_url"])

    # Create job in jobs table based on external values
    # TODO: update mapping of fields
    Job.create(
      title: data["title"],
      description: data["description"],
      location: data["location"],
      seniority: data["seniority"],
      employment_type: data["employment_type"],
      company_name: data["company_name"],
      company_url: data["company_url"],
      external_url: data["external_url"],
      # Map other fields as necessary
    )
  end
end


# ---------------------
# Job Search Schema:
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
