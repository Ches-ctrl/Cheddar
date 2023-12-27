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
  { name: "Kroo", category: "Tech", website_url: "https://kroo.com/" },
  { name: "Deliveroo", category: "Tech", website_url: "https://deliveroo.co.uk/" },
  { name: "BCG Digital Ventures", category: "Tech", website_url: "https://bcgdv.com/" },
  { name: "Cleo", category: "FinTech", website_url: "https://web.meetcleo.com/" },
  { name: "BrainStation", category: "Tech", website_url: "https://brainstation.io/" },
  { name: "Blink", category: "Tech", website_url: "https://www.joinblink.com/" },
  { name: "Builder.ai", category: "Tech", website_url: "https://www.builder.ai/" },
  { name: "9fin", category: "Tech", website_url: "https://9fin.com/" },
  { name: "Quantexa", category: "Tech", website_url: "https://www.quantexa.com/" },
  { name: "Apple Inc", category: "Tech", website_url: "https://apple.com/uk" },
  { name: "Google", category: "Tech", website_url: "https://google.com/" },
  { name: "Meta", category: "Tech", website_url: "https://meta.com/" },
  { name: "Amazon Web Services", category: "Tech", website_url: "https://aws.com/" },
  { name: "Netflix", category: "Tech", website_url: "https://Netflix.com/" },
  { name: "EBay", category: "E-Commerce", website_url: "https://bcgdv.com/" },
  { name: "Microsoft", category: "Tech", website_url: "https://Microsoft.com/" },
  { name: "OpenAI", category: "Tech", website_url: "https://openai.com/" },
  { name: "Tesla", category: "Automotive", website_url: "https://tesla.com/" },
  { name: "BCG Digital Ventures", category: "Tech", website_url: "https://bcgdv.com/" },
  { name: "Uber", category: "Transportation Mobility", website_url: "https://uber.com/" },
  { name: "Samsung", category: "Tech", website_url: "https://samsung.com/" },
  { name: "Intel", category: "Tech", website_url: "https://intel.com/" },
  { name: "Shopify", category: "E-Commerce", website_url: "https://Shopify.com/" },
  { name: "Intel", category: "Tech", website_url: "https://intel.com/" },
  { name: "Sony", category: "Electronics", website_url: "https://Sony.com/" },
  { name: "Etsy", category: "E-Commerce", website_url: "https://Etsy.com/" },
  { name: "Reliance Health", category: "Healthcare", website_url: "https://reliancehealth.com/" },
  { name: "OXK", category: "Crypto", website_url: "https://okx.com/" },
  { name: "Cleo", category: "Finance", website_url: "https://cleo.com/" },
  { name: "Kubernetes", category: "Tech", website_url: "https://kubernetes.com/" },
  { name: "Forter", category: "Tech", website_url: "https://forter.com/" },
  { name: "Synthesia", category: "Tech", website_url: "https://synthesia.com/" },
  { name: "DRW", category: "Finance", website_url: "https://drw.com/" },
  { name: "Wise", category: "Finance", website_url: "https://wise.com/" },
  { name: "Elemental Excelerator", category: "Tech", website_url: "https://elementalexcelerator.com/" },
  { name: "Relativity Space", category: "Tech", website_url: "https://relativityspace.com/" },
  { name: "Zscaler", category: "Tech", website_url: "https://zscaler.com/" },
  { name: "Mozilla", category: "Tech", website_url: "https://mozilla.com/" },
  { name: "Alby", category: "Tech", website_url: "https://alby.com/" },
  { name: "Forage", category: "Tech", website_url: "https://forage.com/" },
  { name: "Tenstorrent", category: "Tech", website_url: "https://tenstorrent.com/" },
  { name: "Jane Street", category: "Finance", website_url: "https://janestreet.com/" },
  { name: "Brain Station", category: "Tech", website_url: "https://brainstation.com/" },
  { name: "GWI", category: "Tech", website_url: "https://gwi.com/" },
  { name: "Monzo", category: "Finance", website_url: "https://monzo.com/" },
  { name: "Jobber", category: "Tech", website_url: "https://jobber.com/" },
  { name: "Tele Health", category: "Healthcare", website_url: "https://telehealth.com/" },
  { name: "Knowde", category: "Tech", website_url: "https://knowde.com/" },
  { name: "Code Path", category: "Tech", website_url: "https://codepath.com/" },
  { name: "Workato", category: "Tech", website_url: "https://workato.com/" },
  { name: "Opendoor", category: "Tech", website_url: "https://opendoor.com/" },
  { name: "Culture Amp", category: "Tech", website_url: "https://cultureamp.com/" },
  { name: "Narvar", category: "Tech", website_url: "https://narvar.com/" },
  { name: "Grammarly", category: "Tech", website_url: "https://grammarly.com/" },
  { name: "Halcyon", category: "Tech", website_url: "https://halcyon.com/" },
  { name: "Motive", category: "Tech", website_url: "https://motive.com/" },
  { name: "Synack", category: "Tech", website_url: "https://synack.com/" },
  { name: "SoSafe GmbH", category: "Tech", website_url: "https://sosafe.com/" },
  { name: "Gemini", category: "Tech", website_url: "https://gemini.com/" }
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

# Later: Add additional fields and change fields e.g. notice_period_weeks
# NB. Whenever changing a field, you need to adjust 3 places: Job Model, User Model and Default Value
# Ideas: access job description details via webpage meta properties rather than by scraping
# May not need an additional hash for application_details if you can access it via the meta tags (provided these are consistent)
# Later: Add capability to deal with recaptcha

# window.careers = {"features":{"smartSEODescription":true,"talentPoolToggleOnACPSave":true,"acpi18n":true,"recaptcha":false,"indeedNewIntegration":true,"prerender":true,"surveys":false},"dimensions":{"i18n":false,"advanced":true,"hasCustomDomain":false}};

# Date created variables
date_created_1 = Date.today - rand(1..14).days
date_created_2 = Date.today - rand(1..14).days
date_created_3 = Date.today - rand(1..14).days
date_created_4 = Date.today - rand(1..14).days
date_created = [date_created_1, date_created_2, date_created_3, date_created_4,]

# Deadline variables
deadline_1 = Date.today.next_week(:friday) + rand(1..7).days
deadline_2 = Date.today.next_week(:friday) + rand(1..7).days
deadline_3 = Date.today.next_week(:friday) + rand(1..7).days
deadline_4 = Date.today.next_week(:friday) + rand(1..7).days

deadlines = [deadline_1, deadline_2, deadline_3, deadline_4,]


# -----------------
# Greenhouse ATS
# -----------------

# https://boards.greenhouse.io/embed/job_app?for=gemini&token=5203656

job_urls = [
  "https://boards.greenhouse.io/ably30/jobs/4183821101",
  "https://boards.greenhouse.io/synthesia/jobs/4250474101",
  "https://boards.greenhouse.io/bcgdv/jobs/6879714002?gh_jid=6879714002",
  "https://boards.greenhouse.io/cleoai/jobs/5033034002",
  "https://boards.greenhouse.io/codepath/jobs/4035988007",
  "https://boards.greenhouse.io/codepath/jobs/4059099007",
  "https://boards.greenhouse.io/codepath/jobs/4141438007",
  "https://boards.greenhouse.io/coreweave/jobs/4241710006",
  "https://boards.greenhouse.io/cultureamp/jobs/5496553",
  "https://boards.greenhouse.io/cultureamp/jobs/5538191",
  "https://boards.greenhouse.io/deliveroo/jobs/5094403",
  "https://boards.greenhouse.io/deliveroo/jobs/5447359",
  "https://boards.greenhouse.io/doctolib/jobs/5811790003",
  "https://boards.greenhouse.io/drweng/jobs/5345753",
  "https://boards.greenhouse.io/elementalexcelerator/jobs/5027131004",
  "https://boards.greenhouse.io/forter/jobs/6889370002",
  "https://boards.greenhouse.io/gemini/jobs/5203656",
  "https://boards.greenhouse.io/globalwebindex/jobs/6940363002",
  "https://boards.greenhouse.io/gomotive/jobs/7025455002",
  "https://boards.greenhouse.io/gomotive/jobs/7030195002",
  "https://boards.greenhouse.io/grammarly/jobs/5523286",
  "https://boards.greenhouse.io/halcyon/jobs/4891571004",
  "https://boards.greenhouse.io/janestreet/jobs/4274809002",
  "https://boards.greenhouse.io/jobber/jobs/7023846002",
  "https://boards.greenhouse.io/joinforage/jobs/4155367007",
  "https://boards.greenhouse.io/knowde/jobs/4129896003",
  "https://boards.greenhouse.io/knowde/jobs/4378100003",
  "https://boards.greenhouse.io/knowde/jobs/4576119003",
  "https://boards.greenhouse.io/knowde/jobs/5808402003",
  "https://boards.greenhouse.io/monzo/jobs/5463167",
  "https://boards.greenhouse.io/monzo/jobs/5482027",
  "https://boards.greenhouse.io/mozilla/jobs/5448569",
  "https://boards.greenhouse.io/narvar/jobs/5388111",
  "https://boards.greenhouse.io/narvar/jobs/5436866",
  "https://boards.greenhouse.io/okx/jobs/5552949003",
  "https://boards.greenhouse.io/opendoor/jobs/4255190006",
  "https://boards.greenhouse.io/relativity/jobs/6916371002",
  "https://boards.greenhouse.io/synack/jobs/5469197",
  "https://boards.greenhouse.io/tenstorrent/jobs/4120628007",
  "https://boards.greenhouse.io/workato/jobs/7016061002",
  "https://boards.greenhouse.io/zscaler/jobs/4092460007"
]




# 6. Gemini
Job.create!(
  job_title: "Cloud Network Engineer @ Gemini ",
  job_description: "Gemini is a crypto exchange and custodian that allows customers to buy, sell, store, and earn more than 30 cryptocurrencies like bitcoin, bitcoin cash, ether, litecoin, and Zcash. Gemini is a New York trust company that is subject to the capital reserve requirements, cybersecurity requirements, and banking compliance standards set forth by the New York State Department of Financial Services and the New York Banking Law. Gemini was founded in 2014 by twin brothers Cameron and Tyler Winklevoss to empower the individual through crypto.",
  salary: 98000,
  job_posting_url: "https://boards.greenhouse.io/embed/job_app?for=gemini&token=5203656",
  company_id: Company.find_by(company_name: 'Gemini').id,
  captcha: false,
  # About Us, Position Overview, Responsibilities, Requirements, Benefits, Application Process
)

# 7. Alby
Job.create!(
  job_title: "Web Engineer - Content @ Ably",
  job_description: "You will be responsible for helping shape the future of our content marketing and publishing platforms. You'll draw on your broad range of expertise across the web stack to design, develop and deliver.",
  salary: 48000,
  job_posting_url: "https://boards.eu.greenhouse.io/ably30/jobs/4183821101",
  company_id: Company.find_by(company_name: 'Alby').id
)

puts "Created job - #{Job.last.job_title}"

# 8. Synthesia
Job.create!(
  job_title: "Webflow Developer @ Synthesia ",
  job_description: "Support full-stack engineering teams, Communicate across functions and drive engineering initiatives,Empathise with and help define product strategy for our target audience.",
  salary: 41000,

  # NB: THIS ALL CONVERTS TO STRING WHEN PARSED TO JSON IN THE DATABASE!

  job_posting_url: "https://boards.eu.greenhouse.io/synthesia/jobs/4250474101",
  company_id: Company.find_by(company_name: 'Synthesia').id
)

puts "Created job - #{Job.last.job_title}"

# 9. BCG Digital Ventures
Job.create!(
  job_title: "Fullstack Engineer: Green-Tech Business",
  job_description: "Part of a new team, we are hiring software engineers to work in squads on developing applications for the company'’'s digital portfolio, built in the Azure ecosystem. You will play a key role in designing, developing, maintaining and improving business'’' key product, thus enabling customers to measure their climate impact.",
  salary: 40000,
  job_posting_url: "https://boards.greenhouse.io/bcgdv/jobs/6879714002?gh_jid=6879714002",
  company_id: Company.find_by(company_name: 'BCG Digital Ventures').id
)

puts "Created job - #{Job.last.job_title}"

# 11. Cleo
Job.create!(
  job_title: "Backend Ruby Engineer",
  job_description: "Most people come to Cleo to do work that matters. Every day, we empower people to build a life beyond their next paycheck, building a beloved AI that enables you to forge your own path toward financial well-being.",
  salary: 40000,
  job_posting_url: "https://boards.greenhouse.io/cleoai/jobs/5033034002",
  company_id: Company.find_by(company_name: 'Cleo').id
)

puts "Created job - #{Job.last.job_title}"

# 12. Coreweave

Job.create!(
  job_title: "Senior Engineer @ Kubernetes Core Interfacesat CoreWeave ",
  job_description: "We are looking for a Senior Engineer - Java (Defi - DEX) to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application. ",
  salary: 38000,
  job_posting_url: "https://boards.greenhouse.io/coreweave/jobs/4241710006",
  company_id: Company.find_by(company_name: 'Kubernetes').id
)

puts "Created job - #{Job.last.job_title}"

# 13. Deliveroo

Job.create!(
  job_title: "Software Engineer II - Full-Stack",
  job_description: "We're building the definitive online food company, transforming the way the world eats by making hyper-local food more convenient and accessible. We obsess about building the future of food, whilst using our network as a force for good. We're at the forefront of an industry, powered by our market-leading technology and unrivalled network to bring incredible convenience and selection to our customers.",
  salary: 31000,
  job_posting_url: "https://boards.greenhouse.io/deliveroo/jobs/5447359",
  company_id: Company.find_by(company_name: 'Deliveroo').id
)

puts "Created job - #{Job.last.job_title}"

# 14. Deliveroo
Job.create!(
  job_title: "Software Engineer - Golang",
  job_description: "We're building the definitive online food company, transforming the way the world eats by making hyper-local food more convenient and accessible. We obsess about building the future of food, whilst using our network as a force for good. We're at the forefront of an industry, powered by our market-leading technology and unrivaled network to bring incredible convenience and selection to our customers.",
  salary: 40000,
  job_posting_url: "https://boards.greenhouse.io/deliveroo/jobs/5094403",
  company_id: Company.find_by(company_name: 'Deliveroo').id
)

puts "Created job - #{Job.last.job_title}"

# 15. DRW
Job.create!(
  job_title: "Software Engineer - Commodities @ DRW   ",
  job_description: "DRW are looking for a Software Engineer to join the Commodities trading group to build and support data pipelines for the ingestion, management, and analysis of datasets used by analysts and traders.",
  salary: 60000,
  job_posting_url: "https://boards.greenhouse.io/drweng/jobs/5345753",
  company_id: Company.find_by(company_name: 'DRW').id
)

puts "Created job - #{Job.last.job_title}"

# 16. Elemental Excelerator
Job.create!(
  job_title: "Developer in Residence @ Elemental Excelerator ",
  job_description: "We are looking for a Developer in Residence to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application. ",
  salary: 29000,
  job_posting_url: "https://boards.greenhouse.io/elementalexcelerator/jobs/5027131004",
  company_id: Company.find_by(company_name: 'Elemental Excelerator').id
)

puts "Created job - #{Job.last.job_title}"

# 17. Forter
Job.create!(
  job_title: "Backend Payment Architech @ Forter",
  job_description: "Payment System Analysis: Conduct payment solution technical requirement deep dives with clients to understand their business goals",
  salary: 43000,
  job_posting_url: "https://boards.greenhouse.io/forter/jobs/6889370002",
  company_id: Company.find_by(company_name: 'Forter').id
)

puts "Created job - #{Job.last.job_title}"

# 18. Jane Street
Job.create!(
  job_title: "FPGA Engineer @ Jane Street",
  job_description: "We are looking for a FPGA Engineer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application. ",
  salary: 43000,
  job_posting_url: "https://boards.greenhouse.io/janestreet/jobs/4274809002",
  company_id: Company.find_by(company_name: 'Jane Street').id
)

puts "Created job - #{Job.last.job_title}"

# 19. Forage
Job.create!(
  job_title: "Principal Backend Engineer @ Forage",
  job_description: "We are looking for a Principal Backend Engineer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application. ",
  salary: 55000,


  job_posting_url: "https://boards.greenhouse.io/joinforage/jobs/4155367007",
  company_id: Company.find_by(company_name: 'Forage').id
)

puts "Created job - #{Job.last.job_title}"

# 20. Mozilla
Job.create!(
  job_title: "Staff Full Stack Software Engineer @ Mozilla",
  job_description: "We are looking for a Staff Full Stack Software Engineer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application. ",
  salary: 81000,
  job_posting_url: "https://boards.greenhouse.io/mozilla/jobs/5448569",
  company_id: Company.find_by(company_name: 'Mozilla').id
)

puts "Created job - #{Job.last.job_title}"

# 21. OKX
Job.create!(
  job_title: "Senior Engineer - Java (Defi - DEX) @ OKX ",
  job_description: "We are looking for a Senior Engineer - Java (Defi - DEX) to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application. ",
  salary: 34000,

  job_posting_url: "https://boards.greenhouse.io/okx/jobs/5552949003",
  company_id: Company.find_by(company_name: 'OXK').id
)

puts "Created job - #{Job.last.job_title}"

# 22. Relativity
Job.create!(
  job_title: "Manager, Tooling Engineering @ Relativity Space",
  job_description: "We are looking for a Manager, Tooling Engineering to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application. ",
  salary: 60000,
  job_posting_url: "https://boards.greenhouse.io/relativity/jobs/6916371002",
  company_id: Company.find_by(company_name: 'Relativity Space').id
)

puts "Created job - #{Job.last.job_title}"

# 23. Tenstorrent
Job.create!(
  job_title: "Staff Emulation Methodology and Infrastructure Engineer @ Tenstorrent",
  job_description: "We are looking for a UI Developer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 35000,
  job_posting_url: "https://boards.greenhouse.io/tenstorrent/jobs/4120628007",
  company_id: Company.find_by(company_name: 'Tenstorrent').id
)

puts "Created job - #{Job.last.job_title}"

# 24. Wise
Job.create!(
  job_title: "Senior Backend Engineer - Fraud @ Wise",
  job_description: "We'’'re looking for a Senior Backend Engineer to join our Fraud team in London. You'’'ll be working on building and improving our fraud detection systems, which are used to protect our customers and Wise from fraudsters. You'’'ll be working in a cross-functional team with other engineers, product managers, data scientists and analysts to build and improve our fraud detection systems.",
  salary: 55000,
  job_posting_url: "https://boards.greenhouse.io/zscaler/jobs/4092460007",
  company_id: Company.find_by(company_name: 'Zscaler').id
)
puts "Created job - #{Job.last.job_title}"
# 26. GWI
Job.create!(
  job_title: "Data Science Talent Pool @ GWI ",
  job_description: "Our Data Science department is split between the Data Analytics Engineering and Data Science teams consisting of Data Scientists and Machine Learning Engineers reporting to the Team Leads under the VP of Data Science or the Director of Data Analytics Engineering. The teams mainly work with GCP, Python and SQL. ",
  salary: 66000,
  job_posting_url: "https://boards.greenhouse.io/globalwebindex/jobs/6940363002",
  company_id: Company.find_by(company_name: 'GWI').id
)
puts "Created job - #{Job.last.job_title}"

# 27. Monzo
Job.create!(
  job_title: "Director of Data Science, Financial Crime @ Monzo ",
  job_description: "We are looking for a Director of Data Science, Financial Crime to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application ",
  salary: 120000,
  job_posting_url: "https://boards.greenhouse.io/monzo/jobs/5463167",
  company_id: Company.find_by(company_name: 'Monzo').id
)
puts "Created job - #{Job.last.job_title}"

# 28. Monzo
Job.create!(
  job_title: "Data science manager @ Monzo ",
  job_description: "We are looking for a Data science manager to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application ",
  salary: 100000,
  job_posting_url: "https://boards.greenhouse.io/monzo/jobs/5482027",
  company_id: Company.find_by(company_name: 'Monzo').id
)
puts "Created job - #{Job.last.job_title}"

# 29. Jobber
Job.create!(
  job_title: "Senior Data Science Manager @ Jobber ",
  job_description: "We are looking for a Senior Data Science Manager to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application ",
  salary: 90000,
  job_posting_url: "https://boards.greenhouse.io/jobber/jobs/7023846002",
  company_id: Company.find_by(company_name: 'Jobber').id
)
puts "Created job - #{Job.last.job_title}"

# 30. tele health
Job.create!(
  job_title: "Software Engineer @ Tele Health ",
  job_description: "We are looking for a Software Engineer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application ",
  salary: 90000,
  job_posting_url: "https://boards.greenhouse.io/doctolib/jobs/5811790003",
  company_id: Company.find_by(company_name: 'Tele Health').id
)
puts "Created job - #{Job.last.job_title}"

# 31. Knowde
Job.create!(
  job_title: "Back-End Software Engineer - Ruby/Rails @ Knowde ",
  job_description: "We are looking for a Back-End Software Engineer - Ruby/Rails to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application ",
  salary: 92000,
  job_posting_url: "https://boards.greenhouse.io/knowde/jobs/4378100003",
  company_id: Company.find_by(company_name: 'Knowde').id
)
puts "Created job - #{Job.last.job_title}"

# 32. Knowde
Job.create!(
  job_title: "Engineering Manager @ Knowde ",
  job_description: "We are looking for a Engineering Manager to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application ",
  salary: 88000,
  job_posting_url: "https://boards.greenhouse.io/knowde/jobs/5808402003",
  company_id: Company.find_by(company_name: 'Knowde').id
)
puts "Created job - #{Job.last.job_title}"

# 33. Knowde
Job.create!(
  job_title: "Front-End Software Engineer @ Knowde ",
  job_description: "We are looking for a Front-End Software Engineer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application ",
  salary: 99000,
  job_posting_url: "https://boards.greenhouse.io/knowde/jobs/4576119003",
  company_id: Company.find_by(company_name: 'Knowde').id
)
puts "Created job - #{Job.last.job_title}"

# 34. Knowde
Job.create!(
  job_title: "Senior Back-End Software Engineer @ Knowde ",
  job_description: "We are looking for a Senior Back-End Software Engineer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 93000,
  job_posting_url: "https://boards.greenhouse.io/knowde/jobs/4129896003",
  company_id: Company.find_by(company_name: 'Knowde').id
)
puts "Created job - #{Job.last.job_title}"

# 35. Code path
Job.create!(
  job_title: "Senior Ruby Engineer @ Codepath ",
  job_description: "We are looking for a Senior Back-End Software Engineer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 89000,
  job_posting_url: "https://boards.greenhouse.io/codepath/jobs/4035988007",
  company_id: Company.find_by(company_name: 'Code Path').id
)
puts "Created job - #{Job.last.job_title}"

# 36. Code path
Job.create!(
  job_title: "Lead Web Development Instructor @ Codepath ",
  job_description: "We are looking for a Lead Web Development Instructor to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 97000,
  job_posting_url: "https://boards.greenhouse.io/codepath/jobs/4059099007",
  company_id: Company.find_by(company_name: 'Code Path').id
)
puts "Created job - #{Job.last.job_title}"

# 37. Code path
Job.create!(
  job_title: "Cloud Infrastructure Engineer @ Codepath",
  job_description: "We are looking for a Cloud Infrastructure Engineer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 97000,
  job_posting_url: "https://boards.greenhouse.io/codepath/jobs/4141438007",
  company_id: Company.find_by(company_name: 'Code Path').id
)
puts "Created job - #{Job.last.job_title}"

# 38. workato
Job.create!(
  job_title: "Senior Ruby Engineer @ Workato",
  job_description: "We are looking for a Senior Ruby Engineer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 97000,
  job_posting_url: "https://boards.greenhouse.io/workato/jobs/7016061002",
  company_id: Company.find_by(company_name: 'Workato').id
)
puts "Created job - #{Job.last.job_title}"

# 39. Open door
Job.create!(
  job_title: "Staff Software Engineer - Ruby on rails OR Golang @ Opendoor",
  job_description: "We are looking for a Staff Software Engineer - Ruby on rails OR Golang to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 91000,
  job_posting_url: "https://boards.greenhouse.io/opendoor/jobs/4255190006",
  company_id: Company.find_by(company_name: 'Opendoor').id
)
puts "Created job - #{Job.last.job_title}"

# 40. Culture Amp
Job.create!(
  job_title: "Senior Engineer - Ruby @ Culture Amp",
  job_description: "We are looking for a Senior Engineer - Ruby to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 89000,
  job_posting_url: "https://boards.greenhouse.io/cultureamp/jobs/5538191",
  company_id: Company.find_by(company_name: 'Culture Amp').id
)
puts "Created job - #{Job.last.job_title}"

# 41. Culture Amp
Job.create!(
  job_title: "Automation Engineer @ Culture Amp",
  job_description: "We are looking for a Automation Engineer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 97000,
  job_posting_url: "https://boards.greenhouse.io/cultureamp/jobs/5496553",
  company_id: Company.find_by(company_name: 'Culture Amp').id
)
puts "Created job - #{Job.last.job_title}"

# 42. Narvar
Job.create!(
  job_title: "Staff Engineer, Ruby on Rails and React @ Narvar",
  job_description: "We are looking for a Staff Engineer, Ruby on Rails and React to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 89000,
  job_posting_url: "https://boards.greenhouse.io/narvar/jobs/5388111",
  company_id: Company.find_by(company_name: 'Narvar').id
)
puts "Created job - #{Job.last.job_title}"

# 43.Narvar
Job.create!(
  job_title: "Director of Machine Learning @ Narvar",
  job_description: "We are looking for a Director of Machine Learning to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 120000,
  job_posting_url: "https://boards.greenhouse.io/narvar/jobs/5436866",
  company_id: Company.find_by(company_name: 'Narvar').id
)
puts "Created job - #{Job.last.job_title}"

# 44. Synack
Job.create!(
  job_title: "Senior Backend Engineer - Ruby on Rails @ Synack",
  job_description: "We are looking for a Senior Backend Engineer - Ruby on Rails to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 110000,
  job_posting_url: "https://boards.greenhouse.io/synack/jobs/5469197",
  company_id: Company.find_by(company_name: 'Synack').id
)
puts "Created job - #{Job.last.job_title}"

# 46. grammarly
Job.create!(
  job_title: "AI Security Researcher -  @ Grammarly",
  job_description: "We are looking for a AI Security Researcher -  to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 120000,
  job_posting_url: "https://boards.greenhouse.io/grammarly/jobs/5523286",
  company_id: Company.find_by(company_name: 'Grammarly').id
)
puts "Created job - #{Job.last.job_title}"

# 47. Halcyon
Job.create!(
  job_title: "Cloud Backend Engineer -  @ Halcyon",
  job_description: "We are looking for a Cloud Backend Engineer -  to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 112000,
  job_posting_url: "https://boards.greenhouse.io/halcyon/jobs/4891571004",
  company_id: Company.find_by(company_name: 'Halcyon').id
)
puts "Created job - #{Job.last.job_title}"

# 49. Motive
Job.create!(
  job_title: "Cloud Infrastructure Engineer -  @ Motive",
  job_description: "We are looking for a Cloud Infrastructure Engineer -  to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 102000,
  job_posting_url: "https://boards.greenhouse.io/gomotive/jobs/7030195002",
  company_id: Company.find_by(company_name: 'Motive').id
)
puts "Created job - #{Job.last.job_title}"

# 50. Motive
Job.create!(
  job_title: "Data Engineer -  @ Motive",
  job_description: "We are looking for a Data Engineer -  to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 101000,
  job_posting_url: "https://boards.greenhouse.io/gomotive/jobs/7025455002",
  company_id: Company.find_by(company_name: 'Motive').id
)
puts "Created job - #{Job.last.job_title}"

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
