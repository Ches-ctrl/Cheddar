# require 'uri'
# require 'net/http'
# require 'json'

puts "Deleting previous (1) users, (2) jobs, (3)companies, (4) ATS Formats and (5) Applicant Tracking Systems..."

puts "-------------------------------------"

User.destroy_all
Job.destroy_all
Company.destroy_all
AtsFormat.destroy_all
ApplicantTrackingSystem.destroy_all

puts "Creating new Applicant Tracking Systems..."

ats_data = [
  { name: "Workable", website_url: "https://workable.com/" },
  { name: "Greenhouse", website_url: "https://greenhouse.io/" },
  { name: "Lever", website_url: "https://lever.co/" },
  { name: "Jobvite", website_url: "https://jobvite.com/" },
  { name: "SmartRecruiters", website_url: "https://smartrecruiters.com/" },
  { name: "Taleo", website_url: "https://taleo.com/" },
  { name: "Workday", website_url: "https://workday.com/" },
  { name: "Ambertrack", website_url: "https://ambertrack.com/" },
  { name: "Tal.net", website_url: "https://tal.net/" },
  { name: "Ashby", website_url: "https://ashbyhq.com/" }
]

ats_data.each do |ats|
  ApplicantTrackingSystem.create(ats)
  puts "Created ATS - #{ApplicantTrackingSystem.last.name}"
end

puts "Created #{ApplicantTrackingSystem.count} ATSs"

puts "-------------------------------------"

puts "Creating new ATS formats..."

ats_formats_data = [
  { name: "Workable_1", ats_name: 'Workable' },
  { name: "Workable_2", ats_name: 'Workable' },
  { name: "Greenhouse_1", ats_name: 'Greenhouse' },
  { name: "Greenhouse_2", ats_name: 'Greenhouse' },
  { name: "Lever_1", ats_name: 'Lever' },
  { name: "Jobvite_1", ats_name: 'Jobvite' },
  { name: "SmartRecruiters_1", ats_name: 'SmartRecruiters' },
  { name: "Taleo_1", ats_name: 'Taleo' },
  { name: "Workday_1", ats_name: 'Workday' },
  { name: "Ambertrack_1", ats_name: 'Ambertrack' },
  { name: "Tal.net_1", ats_name: 'Tal.net' },
  { name: "Ashby_1", ats_name: 'Ashby' }
]

# TODO: Check logic here

ats_formats_data.each do |ats_format_data|
  ats_name = ats_format_data[:ats_name]
  ats_id = ApplicantTrackingSystem.find_by(name: ats_name).id
  ats_format_data[:applicant_tracking_system_id] = ats_id
  ats_format_data.delete(:ats_name)
  AtsFormat.create(ats_format_data)
  puts "Created ATS format - #{AtsFormat.last.name}"
end

puts "Created #{AtsFormat.count} ATS formats"

puts "-------------------------------------"

puts "Creating new companies..."

companies_data = [
  {:name=>"9fin", :category=>"Tech", :website_url=>"https://9fin.com/"},
  {:name=>"Alby", :category=>"Tech", :website_url=>"https://alby.com/"},
  {:name=>"Amazon Web Services", :category=>"Tech", :website_url=>"https://aws.com/"},
  {:name=>"Apple Inc", :category=>"Tech", :website_url=>"https://apple.com/uk"},
  {:name=>"BCG Digital Ventures", :category=>"Tech", :website_url=>"https://bcgdv.com/"},
  # {:name=>"BCG Digital Ventures", :category=>"Tech", :website_url=>"https://bcgdv.com/"},
  {:name=>"Blink", :category=>"Tech", :website_url=>"https://www.joinblink.com/"},
  {:name=>"Brain Station", :category=>"Tech", :website_url=>"https://brainstation.com/"},
  # {:name=>"BrainStation", :category=>"Tech", :website_url=>"https://brainstation.io/"},
  {:name=>"Builder.ai", :category=>"Tech", :website_url=>"https://www.builder.ai/"},
  {:name=>"Cleo", :category=>"Finance", :website_url=>"https://cleo.com/"},
  # {:name=>"Cleo", :category=>"FinTech", :website_url=>"https://web.meetcleo.com/"},
  {:name=>"Code Path", :category=>"Tech", :website_url=>"https://codepath.com/"},
  {:name=>"Culture Amp", :category=>"Tech", :website_url=>"https://cultureamp.com/"},
  {:name=>"DRW", :category=>"Finance", :website_url=>"https://drw.com/"},
  {:name=>"Deliveroo", :category=>"Tech", :website_url=>"https://deliveroo.co.uk/"},
  {:name=>"Elemental Excelerator", :category=>"Tech", :website_url=>"https://elementalexcelerator.com/"},
  {:name=>"Etsy", :category=>"E-Commerce", :website_url=>"https://Etsy.com/"},
  {:name=>"Forage", :category=>"Tech", :website_url=>"https://forage.com/"},
  {:name=>"Forter", :category=>"Tech", :website_url=>"https://forter.com/"},
  {:name=>"GWI", :category=>"Tech", :website_url=>"https://gwi.com/"},
  {:name=>"Gemini", :category=>"Tech", :website_url=>"https://gemini.com/"},
  {:name=>"Google", :category=>"Tech", :website_url=>"https://google.com/"},
  {:name=>"Grammarly", :category=>"Tech", :website_url=>"https://grammarly.com/"},
  {:name=>"Halcyon", :category=>"Tech", :website_url=>"https://halcyon.com/"},
  {:name=>"Intel", :category=>"Tech", :website_url=>"https://intel.com/"},
  # {:name=>"Intel", :category=>"Tech", :website_url=>"https://intel.com/"},
  {:name=>"Jane Street", :category=>"Finance", :website_url=>"https://janestreet.com/"},
  {:name=>"Jobber", :category=>"Tech", :website_url=>"https://jobber.com/"},
  {:name=>"Knowde", :category=>"Tech", :website_url=>"https://knowde.com/"},
  {:name=>"Kroo", :category=>"Tech", :website_url=>"https://kroo.com/"},
  {:name=>"Kubernetes", :category=>"Tech", :website_url=>"https://kubernetes.com/"},
  {:name=>"Meta", :category=>"Tech", :website_url=>"https://meta.com/"},
  {:name=>"Microsoft", :category=>"Tech", :website_url=>"https://Microsoft.com/"},
  {:name=>"Monzo", :category=>"Finance", :website_url=>"https://monzo.com/"},
  {:name=>"Motive", :category=>"Tech", :website_url=>"https://motive.com/"},
  {:name=>"Mozilla", :category=>"Tech", :website_url=>"https://mozilla.com/"},
  {:name=>"Narvar", :category=>"Tech", :website_url=>"https://narvar.com/"},
  {:name=>"Netflix", :category=>"Tech", :website_url=>"https://Netflix.com/"},
  {:name=>"OXK", :category=>"Crypto", :website_url=>"https://okx.com/"},
  {:name=>"OpenAI", :category=>"Tech", :website_url=>"https://openai.com/"},
  {:name=>"Opendoor", :category=>"Tech", :website_url=>"https://opendoor.com/"},
  {:name=>"Quantexa", :category=>"Tech", :website_url=>"https://www.quantexa.com/"},
  {:name=>"Relativity Space", :category=>"Tech", :website_url=>"https://relativityspace.com/"},
  {:name=>"Reliance Health", :category=>"Healthcare", :website_url=>"https://reliancehealth.com/"},
  {:name=>"Samsung", :category=>"Tech", :website_url=>"https://samsung.com/"},
  {:name=>"Shopify", :category=>"E-Commerce", :website_url=>"https://Shopify.com/"},
  {:name=>"SoSafe GmbH", :category=>"Tech", :website_url=>"https://sosafe.com/"},
  {:name=>"Sony", :category=>"Electronics", :website_url=>"https://Sony.com/"},
  {:name=>"Synack", :category=>"Tech", :website_url=>"https://synack.com/"},
  {:name=>"Synthesia", :category=>"Tech", :website_url=>"https://synthesia.com/"},
  {:name=>"Tele Health", :category=>"Healthcare", :website_url=>"https://telehealth.com/"},
  {:name=>"Tenstorrent", :category=>"Tech", :website_url=>"https://tenstorrent.com/"},
  {:name=>"Tesla", :category=>"Automotive", :website_url=>"https://tesla.com/"},
  {:name=>"Uber", :category=>"Transportation Mobility", :website_url=>"https://uber.com/"},
  {:name=>"Wise", :category=>"Finance", :website_url=>"https://wise.com/"},
  {:name=>"Workato", :category=>"Tech", :website_url=>"https://workato.com/"},
  {:name=>"Zscaler", :category=>"Tech", :website_url=>"https://zscaler.com/"}
]

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

puts "Creating new jobs..."

# TODO: Setup iframe for external embeds?
# TODO: Create aliases for company_names

# -----------------
# Greenhouse ATS
# -----------------

job_urls = [
  "https://boards.greenhouse.io/ambientai/jobs/4301104006",
  "https://boards.greenhouse.io/bcgdv/jobs/6879714002",
  "https://boards.greenhouse.io/cleoai/jobs/5033034002",
  "https://boards.greenhouse.io/codepath/jobs/4035988007",
  "https://boards.greenhouse.io/codepath/jobs/4059099007",
  "https://boards.greenhouse.io/codepath/jobs/4141438007",
  "https://boards.greenhouse.io/coreweave/jobs/4241710006",
  "https://boards.greenhouse.io/css/jobs/6975614002",
  "https://boards.greenhouse.io/cultureamp/jobs/5496553",
  "https://boards.greenhouse.io/cultureamp/jobs/5538191",
  "https://boards.greenhouse.io/deliveroo/jobs/5094403",
  "https://boards.greenhouse.io/deliveroo/jobs/5447359",
  "https://boards.greenhouse.io/doctolib/jobs/5811790003",
  "https://boards.greenhouse.io/doctolib/jobs/5828747003",
  "https://boards.greenhouse.io/drweng/jobs/5345753",
  "https://boards.greenhouse.io/elementalexcelerator/jobs/5027131004",
  "https://boards.greenhouse.io/forter/jobs/6889370002",
  "https://boards.greenhouse.io/gemini/jobs/5203656",
  "https://boards.greenhouse.io/getir/jobs/4258936101",
  "https://boards.greenhouse.io/globalwebindex/jobs/6940363002",
  "https://boards.greenhouse.io/gomotive/jobs/7025455002",
  "https://boards.greenhouse.io/gomotive/jobs/7030195002",
  "https://boards.greenhouse.io/grammarly/jobs/5523286",
  "https://boards.greenhouse.io/gusto/jobs/5535268",
  "https://boards.greenhouse.io/halcyon/jobs/4891571004",
  "https://boards.greenhouse.io/janestreet/jobs/4274809002",
  "https://boards.greenhouse.io/janestreet/jobs/6102180002",
  "https://boards.greenhouse.io/jobber/jobs/7023846002",
  "https://boards.greenhouse.io/joinforage/jobs/4155367007",
  "https://boards.greenhouse.io/knowde/jobs/4129896003",
  "https://boards.greenhouse.io/knowde/jobs/4378100003",
  "https://boards.greenhouse.io/knowde/jobs/4576119003",
  "https://boards.greenhouse.io/knowde/jobs/5808402003",
  "https://boards.greenhouse.io/monzo/jobs/5410348",
  "https://boards.greenhouse.io/monzo/jobs/5463167",
  "https://boards.greenhouse.io/monzo/jobs/5482027",
  "https://boards.greenhouse.io/mozilla/jobs/5448569",
  "https://boards.greenhouse.io/narvar/jobs/5388111",
  "https://boards.greenhouse.io/narvar/jobs/5436866",
  "https://boards.greenhouse.io/niantic/jobs/7068655002",
  "https://boards.greenhouse.io/okx/jobs/5552949003",
  "https://boards.greenhouse.io/opendoor/jobs/4255190006",
  "https://boards.greenhouse.io/phonepe/jobs/5816286003",
  "https://boards.greenhouse.io/relativity/jobs/6916371002",
  "https://boards.greenhouse.io/remotecom/jobs/5756728003",
  "https://boards.greenhouse.io/samsara/jobs/5580492",
  "https://boards.greenhouse.io/settle/jobs/4350962005",
  "https://boards.greenhouse.io/springhealth66/jobs/4336742005",
  "https://boards.greenhouse.io/synack/jobs/5469197",
  "https://boards.greenhouse.io/synthesia/jobs/4250474101",
  "https://boards.greenhouse.io/teads/jobs/5529600",
  "https://boards.greenhouse.io/tenstorrent/jobs/4120628007",
  "https://boards.greenhouse.io/workato/jobs/7016061002",
  "https://boards.greenhouse.io/zscaler/jobs/4092460007"
]

# TODO: Add collect additional company postings functionality

job_urls.each do |url|
  company = CompanyCreator.new(url).find_or_create_company
  p "CompanyCreator complete: #{company.company_name}"

  job = Job.create!(
    job_title: "Job Title Placeholder",
    job_posting_url: url,
    company_id: company.id,
  )

  JobCreator.new(job).add_job_details
  p "Created job - #{Job.last.job_title}"
end

puts "Created #{job_urls.count} jobs based on the provided URLs."

job_urls_embedded = [
  "https://bolt.eu/en/careers/positions/6989975002",
  "https://careers.datadoghq.com/detail/4452892",
  "https://jobs.elastic.co/form?gh_jid=5518454",
  "https://ripple.com/careers/all-jobs/job/5144512",
  "https://www.hubspot.com/careers/jobs/5402223",
  "https://www.mongodb.com/careers/jobs/5424409",
  "https://www.noredink.com/job_post?gh_jid=5586486",
  "https://www.onemedical.com/careers/all-departments/5433427",
  "https://www.sumup.com/careers/positions/london-united-kingdom/engineering/engineering-manager-mobile-global-bank/6970735002",
  "https://www.zilch.com/uk/job/?gh_jid=5045377004",
]

puts "Created #{Job.count} jobs..."

puts "-------------------------------------"

puts "Creating admins..."

# Admin user
User.create(
  email: ENV['ADMIN_EMAIL'],
  password: ENV['ADMIN_PASSWORD'],
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

# User.create(
#   email: "email4@gmail.com",
#   password: "password",
#   first_name: "Charlotte",
#   last_name: "the genius",
#   address_first: "15 Hackney Drive",
#   address_second: "London",
#   post_code: "E1 3KR",
#   city: "London",
#   resume: "public/Obtretetskiy_cv.pdf",
#   salary_expectation_text: "£30,000 - £40,000",
#   right_to_work: /yes/i,
#   salary_expectation_figure: 30000,
#   notice_period: 12,
#   preferred_pronoun_select: /he\/him/i,
#   preferred_pronoun_text: 'N/A',
#   employee_referral: "no",
#   admin: false)

# puts "Created user:  #{User.last.first_name}"

puts "Created #{User.count} users..."

puts "-------------------------------------"

5.times do |_application|
  JobApplication.create(
    status: "Pre-test",
    user_id: User.all.sample.id,
    job_id: Job.all.sample.id
  )
  puts "Created job application for #{User.first.first_name} for #{Job.first.job_title}"
end

puts "Created #{JobApplication.count} job applications..."

puts "-------------------------------------"

puts ApplicantTrackingSystem.all
puts ApplicantTrackingSystem.count
puts "-------------------------------------"
puts AtsFormat.all
puts AtsFormat.count
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

puts "Done!"

# PgSearch::Multisearch.rebuild(Job)
# PgSearch::Multisearch.rebuild(Company)
