puts "\nHow many jobs to seed in the database?\n"

response = nil
until response do
  puts "Please enter a valid integer between 1 and 500:"
  response = gets.chomp
  if response == 'run updater'
    Scraper::DevitJob.perform_later
    # ImportCompaniesFromList.new.call
    # Xml::WorkableJob.perform_later
    ScrapeTrueUpJob.perform_later
    ExistingJobsUpdaterJob.perform_later
    response = 1
  else
    response = response.to_i
    response = nil if response.zero? || response > 500
  end
end

puts "Preparing to re-seed database with #{response} Greenhouse jobs...\n"

puts "Deleting previous (1) users, (2) jobs, (3)companies, (4) ATS Formats, (5) Applicant Tracking Systems, (6) Locations, (7) Countries, (8) Roles..."

puts "-------------------------------------"

User.destroy_all
Job.destroy_all
Company.destroy_all
ApplicantTrackingSystem.destroy_all
Location.destroy_all
Country.destroy_all
Role.destroy_all

puts "Creating new Applicant Tracking Systems..."

ats_csv = 'storage/csv/ats_systems.csv'

CSV.foreach(ats_csv, headers: true) do |row|
  ats_name = row["ats_name"]
  ats = find_or_create_applicant_tracking_system(ats_name)

  attributes_to_update = {
    url_identifier: row["url_identifier"],
    website_url: row["website_url"],
    url_linkedin: row["url_linkedin"],
    base_url_main: row["base_url_main"],
    base_url_api: row["base_url_api"],
    url_all_jobs: row["url_all_jobs"],
    url_xml: row["url_xml"],
    url_rss: row["url_rss"],
    login: row["login"],
  }

  ats.update(attributes_to_update)

  if ats
    puts "Created ATS - #{ApplicantTrackingSystem.last.name}"
  else
    p "Error creating ATS: #{ats_name}"
  end
end

puts "Created #{ApplicantTrackingSystem.count} ATSs"

puts "-------------------------------------"

greenhouse_companies = [
  "cleoai",
  "ably30",
  "11fs",
  "clearscoretechnologylimited",
  # "codepath",
  # "copperco",
  # "coreweave",
  # "cultureamp",
  # "deliveroo",
  # "doctolib",
  # "epicgames",
  # "figma",
  # "forter",
  # "geniussports",
  # "getir",
  # "gomotive",
  # "grammarly",
  # "intercom",
  # "janestreet",
  # "knowde",
  # "narvar",
  # "niantic",
  # "opendoor"
]

# NB. Doesn't do anything at the moment - needs linking up

puts "Creating new companies..."

companies_data = []

companies_data.each do |company_data|
  Company.create(
    company_name: company_data[:name],
    company_category: company_data[:category],
    company_website_url: company_data[:website_url]
  )
  puts "Created company - #{Company.last.company_name}"
end

puts "Created #{Company.count} companies"

puts "-------------------------------------"

puts "Creating new roles..."

roles = %w(front_end back_end full_stack dev_ops qa_test_engineer mobile data_engineer)
roles.each { | role| Role.create(name: role) }

puts "Created #{Role.count} roles"

puts "-------------------------------------"

puts "Creating new jobs (from GH API)..."

defunct_urls = []

puts "\nBuilding a list of job urls from the following companies:"

relevant_job_urls = GetRelevantJobUrls.new(greenhouse_companies).fetch_jobs
jobs_to_seed = relevant_job_urls.shuffle.take(response)

jobs_to_seed.each do |url|
  CreateJobByUrl.new(url).call
end

puts "Created #{Job.count} jobs..."

puts "-------------------------------------"

puts "Creating admins..."

# Admin user

if Rails.env.production?
  email = ENV['ADMIN_EMAIL']
  password = ENV['ADMIN_PASSWORD']
else
  email = 'admin@cheddarjobs.com'
  password = 'password'
end

User.create(
  email: email,
  password: password,
  first_name: "Charlotte",
  last_name: "Boyd",
  phone_number: "+447874943555",
  address_first: "14 Knapp Drive",
  address_second: "London",
  post_code: "E1 7SH",
  city: "London",
  # resume: "public/Obtretetskiy_cv.pdf",
  salary_expectation_text: "£30,000 - £40,000",
  # right_to_work: /yes/i,
  salary_expectation_figure: 30000,
  notice_period: 12,
  # preferred_pronoun_select: /he\/him/i,
  preferred_pronoun_text: 'N/A',
  employee_referral: "no",
  admin: true)

puts "Created admin user:  #{User.last.first_name}"

# Admin user
User.create(
  email: ENV['CHARLIE_EMAIL'],
  password: ENV['CHARLIE_PASSWORD'],
  first_name: "Charlie",
  last_name: "Cheesman",
  address_first: "Le Haynes",
  address_second: "London",
  post_code: "E5 6KK",
  city: "London",
  # resume: "public/Obtretetskiy_cv.pdf",
  salary_expectation_text: "£30,000 - £40,000",
  # right_to_work: /yes/i,
  salary_expectation_figure: 30000,
  notice_period: 12,
  # preferred_pronoun_select: /he\/him/i,
  preferred_pronoun_text: 'N/A',
  employee_referral: "no",
  admin: true)

puts "Created admin user:  #{User.last.first_name}"

puts "Created #{User.count} admins..."

puts "-------------------------------------"

puts "Creating default user..."

# Default user
User.create(
  email: "usermissingemail@getcheddar.xyz",
  password: ENV['ADMIN_PASSWORD'],
  first_name: "UserMissingFirst",
  last_name: "UserMissingLast",
  phone_number: "+447555555555",
  address_first: "99 Missing Drive",
  address_second: "Missingham",
  post_code: "M1 1MM",
  city: "Missingdon",
  # resume: "public/Obtretetskiy_cv.pdf",
  salary_expectation_text: "£Missing - £Missing",
  # right_to_work: /yes/i,
  salary_expectation_figure: 99999,
  notice_period: 12,
  # preferred_pronoun_select: /he\/him/i,
  preferred_pronoun_text: 'N/A',
  employee_referral: "Missing",
  admin: false)

puts "Created default user:  #{User.last.first_name}"

puts "Created #{User.count} default users..."

puts "-------------------------------------"

puts "Creating standard users..."

User.create(
  email: "email2@gmail.com",
  password: "password",
  first_name: "Ilya",
  last_name: "the russian hacker",
  address_first: "15 Hackney Drive",
  address_second: "London",
  post_code: "E1 3KR",
  city: "London",
  # resume: "public/Obtretetskiy_cv.pdf",
  salary_expectation_text: "£30,000 - £40,000",
  # right_to_work: /yes/i,
  salary_expectation_figure: 30000,
  notice_period: 12,
  # preferred_pronoun_select: /he\/him/i,
  preferred_pronoun_text: 'N/A',
  employee_referral: "no",
  admin: false)

puts "Created user:  #{User.last.first_name}"

User.create(
  email: "d@gmail.com",
  password: "password",
  first_name: "Direncan",
  last_name: "the mysterious",
  address_first: "15 Hackney Drive",
  address_second: "London",
  post_code: "E1 3KR",
  city: "London",
  # resume: "public/Obtretetskiy_cv.pdf",
  salary_expectation_text: "£30,000 - £40,000",
  # right_to_work: /yes/i,
  salary_expectation_figure: 30000,
  notice_period: 12,
  # preferred_pronoun_select: /he\/him/i,
  preferred_pronoun_text: 'N/A',
  employee_referral: "no",
  admin: false)

puts "Created user:  #{User.last.first_name}"

User.create(
  email: "email3@gmail.com",
  password: "password",
  first_name: "Direncan",
  last_name: "the mysterious",
  address_first: "15 Hackney Drive",
  address_second: "London",
  post_code: "E1 3KR",
  city: "London",
  # resume: "public/Obtretetskiy_cv.pdf",
  salary_expectation_text: "£30,000 - £40,000",
  # right_to_work: /yes/i,
  salary_expectation_figure: 30000,
  notice_period: 12,
  # preferred_pronoun_select: /he\/him/i,
  preferred_pronoun_text: 'N/A',
  employee_referral: "no",
  admin: false)

puts "Created user:  #{User.last.first_name}"

puts "Created #{User.count} users..."

puts "-------------------------------------"

5.times do |_application|
  JobApplication.create(
    status: "Pre-test",
    user_id: User.all.sample.id,
    job_id: Job.all.sample.id
  )
  puts "Created job application"
end

5.times do |_application|
  JobApplication.create(
    status: "Applied",
    user_id: User.find_by(first_name: "Charlotte", last_name: "Boyd").id,
    job_id: Job.all.sample.id
  )
  puts "Created job application"
end

puts "Created #{JobApplication.count} job applications..."

puts "-------------------------------------"

puts ApplicantTrackingSystem.all
puts ApplicantTrackingSystem.count
puts "-------------------------------------"
puts Company.all
puts Company.count
puts "-------------------------------------"
puts Job.all
puts Job.count
puts "-------------------------------------"
puts User.all
puts User.count
puts "-------------------------------------"
puts JobApplication.all
puts JobApplication.count
puts "-------------------------------------"

puts "Done!\n"

puts "The following urls refer to jobs that are no longer live and should be deleted from the seedfile:" unless defunct_urls.empty?
defunct_urls.each do |url|
  puts url
end


# -----------------
# Tal.net ATS
# -----------------

# tal_site_urls = [
#   "https://fco.tal.net/candidate",
#   "https://justicejobs.tal.net/candidate",
#   "https://homeofficejobs.tal.net/candidate",
#   "https://theroyalhousehold.tal.net/candidate",
#   "https://housesofparliament.tal.net/candidate",
#   "https://environmentagencyjobs.tal.net/candidate",
#   "https://policecareers.tal.net/candidate",
#   "https://thamesvalleypolice.tal.net/candidate",
#   "https://ual.tal.net/candidate/",
# ]

# gov_uk_site_urls = [
#   "https://www.civilservicejobs.service.gov.uk/csr/index.cgi",
#   "https://jobs.justice.gov.uk/",
#   "https://careers.homeoffice.gov.uk/",
#   "https://www.jobs.nhs.uk/candidate",
# ]

# tal_job_urls = [
#   "https://kornferry.tal.net/vx/lang-en-GB/mobile-0/appcentre-1/brand-4/user-72902/xf-eeb733132400/candidate/so/pm/1/pl/2/opp/15864-Digital-Delivery-Total-Rewards-Intern-Analyst-1-Year-Contract/en-GB",
# ]

# # -----------------
# # Ambertrack ATS
# # -----------------

# ambertrack_site_urls = [
#   "https://eycareers.ambertrack.global/studentrecruitment2024/candidatelogin.aspx?cookieCheck=true",
#   "https://networkrailcandidate.ambertrack.global/apprenticeshipsspring2022/Login.aspx?cookieCheck=true",
#   "https://kentgraduates.ambertrack.co.uk/kentgraduates2024/CandidateLogin.aspx?e=401&cookieCheck=true",
#   "https://atkinscandidate.ambertrack.co.uk/graduates2023/login.aspx?cookieCheck=true",
# ]
