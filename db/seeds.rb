# require 'uri'
# require 'net/http'
# require 'json'

puts "\nBuilding a list of job urls from the following companies:"

greenhouse_company_ats_identifiers = [
  "cleoai",
  "ably30",
  "11fs",
  "clearscoretechnologylimited",
  "codepath",
  "copperco",
  "coreweave",
  "cultureamp",
  "deliveroo",
  "doctolib",
  "epicgames",
  "figma",
  "forter",
  "geniussports",
  "getir",
  "gomotive",
  "grammarly",
  "intercom",
  "janestreet",
  "knowde",
  "narvar",
  "niantic",
  "opendoor"
]

relevant_job_urls = GetRelevantJobUrls.new(greenhouse_company_ats_identifiers).fetch_jobs

puts "\nHow many jobs to seed in the database?\n"

response = nil
until response do
  puts "Please enter a valid integer between 1 and #{relevant_job_urls.count}:"
  response = gets.chomp.to_i
  response = nil if response.zero? || response > relevant_job_urls.count
end

jobs_to_seed = relevant_job_urls.shuffle.take(response)

puts "Preparing to re-seed database with #{jobs_to_seed.count} Greenhouse jobs...\n"

puts "Deleting previous (1) users, (2) jobs, (3)companies, (4) ATS Formats and (5) Applicant Tracking Systems..."

puts "-------------------------------------"

User.destroy_all
Job.destroy_all
Company.destroy_all
# AtsFormat.destroy_all
ApplicantTrackingSystem.destroy_all

puts "Creating new Applicant Tracking Systems..."

ats_data = [
  { name: "Greenhouse",
    website_url: "https://greenhouse.io/",
    base_url_main: "https://boards.greenhouse.io/",
    base_url_api: "https://boards-api.greenhouse.io/v1/boards/",
  },
  { name: "Workable",
    website_url: "https://workable.com/",
    all_jobs_url: "https://jobs.workable.com/",
    base_url_main: "https://apply.workable.com/",
    base_url_api: "https://apply.workable.com/api/v1/accounts/",
  },
  { name: "Lever",
    website_url: "https://lever.co/",
    base_url_main: "https://jobs.lever.co/",
    base_url_api: "https://api.lever.co/v0/postings/",
  },
  { name: "Smartrecruiters",
    website_url: "https://smartrecruiters.com/",
    all_jobs_url: "https://jobs.smartrecruiters.com/",
    base_url_main: "https://jobs.smartrecruiters.com/",
    base_url_api: "https://api.smartrecruiters.com/v1/companies/",
  },
  { name: "Ashbyhq",
    website_url: "https://ashbyhq.com/",
    base_url_main: "https://jobs.ashbyhq.com/",
    base_url_api: "https://api.ashbyhq.com/posting-api/job-board/",
  },
  { name: "Pinpointhq",
    website_url: "https://www.pinpointhq.com/",
    base_url_main: "https://XXX.pinpointhq.com/en/postings/",
    base_url_api: "https://XXX.pinpointhq.com/",
  },
  { name: "Bamboohr",
    website_url: "https://www.bamboohr.com/",
    base_url_main: "https://XXX.bamboohr.com/careers/",
    base_url_api: "https://XXX.bamboohr.com/careers/list",
  },
  { name: "Recruitee",
    website_url: "https://recruitee.com/",
    base_url_main: "https://XXX.recruitee.com/",
    base_url_api: "https://XXX.recruitee.com/api/offers/",
  },
  { name: "Manatal",
    website_url: "https://www.manatal.com/",
    base_url_main: "https://www.careers-page.com/",
    base_url_api: "https://api.manatal.com/open/v3/career-page/",
  },
  { name: "Workday",
    website_url: "https://www.workday.com/",
    base_url_main: "https://XXX.wd1.myworkdayjobs.com/en-US/GTI/",
  },
  { name: "Tal.net",
    website_url: "https://tal.net/",
    all_jobs_url: "https://XXX.tal.net/candidate/",
  },
  { name: "TotalJobs",
    website_url: "https://www.totaljobs.com/",
  },
  { name: "Simplyhired",
    website_url: "https://www.simplyhired.co.uk/",
  },
  { name: "Jobvite",
    website_url: "https://jobvite.com/",
  },
  { name: "Taleo",
    website_url: "https://taleo.com/",
  },
  { name: "Ambertrack",
    website_url: "https://ambertrack.com/",
  },
]

ats_data.each do |ats|
  ApplicantTrackingSystem.create(ats)
  puts "Created ATS - #{ApplicantTrackingSystem.last.name}"
end

puts "Created #{ApplicantTrackingSystem.count} ATSs"

puts "-------------------------------------"

puts "Creating new companies..."

companies_data = [
  # {:name=>"9fin", :category=>"Tech", :website_url=>"https://9fin.com/"},
  # {:name=>"11:FS", :category=>"Tech", :website_url=>"https://www.11fs.com/"},
#   {:name=>"Alby", :category=>"Tech", :website_url=>"https://alby.com/"},
#   {:name=>"Amazon Web Services", :category=>"Tech", :website_url=>"https://aws.com/"},
#   {:name=>"Apple Inc", :category=>"Tech", :website_url=>"https://apple.com/uk"},
#   {:name=>"BCG Digital Ventures", :category=>"Tech", :website_url=>"https://bcgdv.com/"},
#   # {:name=>"BCG Digital Ventures", :category=>"Tech", :website_url=>"https://bcgdv.com/"},
#   {:name=>"Blink", :category=>"Tech", :website_url=>"https://www.joinblink.com/"},
#   {:name=>"Brain Station", :category=>"Tech", :website_url=>"https://brainstation.com/"},
#   # {:name=>"BrainStation", :category=>"Tech", :website_url=>"https://brainstation.io/"},
#   {:name=>"Builder.ai", :category=>"Tech", :website_url=>"https://www.builder.ai/"},
#   {:name=>"Cleo", :category=>"Finance", :website_url=>"https://cleo.com/"},
#   # {:name=>"Cleo", :category=>"FinTech", :website_url=>"https://web.meetcleo.com/"},
#   {:name=>"Code Path", :category=>"Tech", :website_url=>"https://codepath.com/"},
#   {:name=>"Culture Amp", :category=>"Tech", :website_url=>"https://cultureamp.com/"},
#   {:name=>"DRW", :category=>"Finance", :website_url=>"https://drw.com/"},
#   {:name=>"Deliveroo", :category=>"Tech", :website_url=>"https://deliveroo.co.uk/"},
#   {:name=>"Elemental Excelerator", :category=>"Tech", :website_url=>"https://elementalexcelerator.com/"},
#   {:name=>"Etsy", :category=>"E-Commerce", :website_url=>"https://Etsy.com/"},
#   {:name=>"Forage", :category=>"Tech", :website_url=>"https://forage.com/"},
#   {:name=>"Forter", :category=>"Tech", :website_url=>"https://forter.com/"},
#   {:name=>"GWI", :category=>"Tech", :website_url=>"https://gwi.com/"},
#   {:name=>"Gemini", :category=>"Tech", :website_url=>"https://gemini.com/"},
#   {:name=>"Google", :category=>"Tech", :website_url=>"https://google.com/"},
#   {:name=>"Grammarly", :category=>"Tech", :website_url=>"https://grammarly.com/"},
#   {:name=>"Halcyon", :category=>"Tech", :website_url=>"https://halcyon.com/"},
#   {:name=>"Intel", :category=>"Tech", :website_url=>"https://intel.com/"},
#   # {:name=>"Intel", :category=>"Tech", :website_url=>"https://intel.com/"},
#   {:name=>"Jane Street", :category=>"Finance", :website_url=>"https://janestreet.com/"},
#   {:name=>"Jobber", :category=>"Tech", :website_url=>"https://jobber.com/"},
#   {:name=>"Knowde", :category=>"Tech", :website_url=>"https://knowde.com/"},
#   {:name=>"Kroo", :category=>"Tech", :website_url=>"https://kroo.com/"},
#   {:name=>"Kubernetes", :category=>"Tech", :website_url=>"https://kubernetes.com/"},
#   {:name=>"Meta", :category=>"Tech", :website_url=>"https://meta.com/"},
#   {:name=>"Microsoft", :category=>"Tech", :website_url=>"https://Microsoft.com/"},
#   {:name=>"Monzo", :category=>"Finance", :website_url=>"https://monzo.com/"},
#   {:name=>"Motive", :category=>"Tech", :website_url=>"https://motive.com/"},
#   {:name=>"Mozilla", :category=>"Tech", :website_url=>"https://mozilla.com/"},
#   {:name=>"Narvar", :category=>"Tech", :website_url=>"https://narvar.com/"},
#   {:name=>"Netflix", :category=>"Tech", :website_url=>"https://Netflix.com/"},
#   {:name=>"OXK", :category=>"Crypto", :website_url=>"https://okx.com/"},
#   {:name=>"OpenAI", :category=>"Tech", :website_url=>"https://openai.com/"},
#   {:name=>"Opendoor", :category=>"Tech", :website_url=>"https://opendoor.com/"},
#   {:name=>"Quantexa", :category=>"Tech", :website_url=>"https://www.quantexa.com/"},
#   {:name=>"Relativity Space", :category=>"Tech", :website_url=>"https://relativityspace.com/"},
#   {:name=>"Reliance Health", :category=>"Healthcare", :website_url=>"https://reliancehealth.com/"},
#   {:name=>"Samsung", :category=>"Tech", :website_url=>"https://samsung.com/"},
#   {:name=>"Shopify", :category=>"E-Commerce", :website_url=>"https://Shopify.com/"},
#   {:name=>"SoSafe GmbH", :category=>"Tech", :website_url=>"https://sosafe.com/"},
#   {:name=>"Sony", :category=>"Electronics", :website_url=>"https://Sony.com/"},
#   {:name=>"Synack", :category=>"Tech", :website_url=>"https://synack.com/"},
#   {:name=>"Synthesia", :category=>"Tech", :website_url=>"https://synthesia.com/"},
#   {:name=>"Tele Health", :category=>"Healthcare", :website_url=>"https://telehealth.com/"},
#   {:name=>"Tenstorrent", :category=>"Tech", :website_url=>"https://tenstorrent.com/"},
#   {:name=>"Tesla", :category=>"Automotive", :website_url=>"https://tesla.com/"},
#   {:name=>"Uber", :category=>"Transportation Mobility", :website_url=>"https://uber.com/"},
#   {:name=>"Wise", :category=>"Finance", :website_url=>"https://wise.com/"},
#   {:name=>"Workato", :category=>"Tech", :website_url=>"https://workato.com/"},
#   {:name=>"Zscaler", :category=>"Tech", :website_url=>"https://zscaler.com/"}
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

greenhouse_job_urls = [
  "https://boards.greenhouse.io/11fs/jobs/4296543101",
  "https://boards.greenhouse.io/clearscoretechnologylimited/jobs/4269717101",
  "https://boards.greenhouse.io/cleoai/jobs/5033034002",
  "https://boards.greenhouse.io/codepath/jobs/4035988007",
  "https://boards.greenhouse.io/copperco/jobs/4243269101",
  "https://boards.greenhouse.io/coreweave/jobs/4241710006",
  "https://boards.greenhouse.io/cultureamp/jobs/5538191",
  "https://boards.greenhouse.io/deliveroo/jobs/5435632",
  "https://boards.greenhouse.io/deliveroo/jobs/5091928",
  "https://boards.greenhouse.io/deliveroo/jobs/5362266",
  "https://boards.greenhouse.io/doctolib/jobs/5811790003",
  "https://boards.greenhouse.io/doctolib/jobs/5771910003",
  "https://boards.greenhouse.io/epicgames/jobs/4969053004",
  "https://boards.greenhouse.io/figma/jobs/5039807004",
  "https://boards.greenhouse.io/forter/jobs/6889370002",
  "https://boards.greenhouse.io/geniussports/jobs/5693417003",
  "https://boards.greenhouse.io/getir/jobs/4258936101",
  "https://boards.greenhouse.io/gomotive/jobs/7030195002",
  "https://boards.greenhouse.io/grammarly/jobs/5523286",
  # "https://boards.greenhouse.io/helsing/jobs/4129902101",
  "https://boards.greenhouse.io/intercom/jobs/4763765",
  "https://boards.greenhouse.io/janestreet/jobs/4274809002",
  "https://boards.greenhouse.io/janestreet/jobs/6102180002",
  "https://boards.greenhouse.io/knowde/jobs/4129896003",
  "https://boards.greenhouse.io/knowde/jobs/4378100003",
  "https://boards.greenhouse.io/knowde/jobs/4576119003",
  "https://boards.greenhouse.io/narvar/jobs/5388111",
  "https://boards.greenhouse.io/niantic/jobs/7068655002",
  # "https://boards.greenhouse.io/openai/jobs/4907945004", OPENAI JOBS HAVE MIGRATED TO ASHBYHQ, NO LONGER ON GREENHOUSE
  "https://boards.greenhouse.io/opendoor/jobs/4255190006",
  # "https://boards.greenhouse.io/neo4j/jobs/4309978006",
  # "https://boards.greenhouse.io/phonepe/jobs/5816286003",
  # "https://boards.greenhouse.io/point72/jobs/7061105002",
  # "https://boards.greenhouse.io/prolific/jobs/4272099101",
  # "https://boards.greenhouse.io/relativity/jobs/6916371002",
  # "https://boards.greenhouse.io/remotecom/jobs/5756728003",
  # "https://boards.greenhouse.io/samsara/jobs/5580492",
  # "https://boards.greenhouse.io/settle/jobs/4350962005",
  # # "https://boards.eu.greenhouse.io/speechmatics/jobs/4261341101",
  # "https://boards.greenhouse.io/springhealth66/jobs/4336742005",
  # "https://boards.greenhouse.io/stenn/jobs/4262887101",
  # "https://boards.greenhouse.io/superpayments/jobs/4271055101",
  # "https://boards.greenhouse.io/synack/jobs/5469197",
  # "https://boards.greenhouse.io/synthesia/jobs/4250474101",
  # "https://boards.greenhouse.io/talos/jobs/5040783004",
  # "https://boards.greenhouse.io/teads/jobs/5529600",
  # "https://boards.greenhouse.io/tenstorrent/jobs/4120628007",
  # "https://boards.greenhouse.io/transferwise/jobs/5479877",
  # "https://boards.greenhouse.io/watershedclimate/jobs/4698719004",
  # "https://boards.greenhouse.io/workato/jobs/7016061002",
  # "https://boards.greenhouse.io/zscaler/jobs/4092460007",
]

greenhouse_job_urls_embedded = [
  # The problem with the first of these jobs is that Capybara encounters a 404. I suspect it's trying to click the wrong apply button. The specific error is JSON::ParserError: 859: unexpected token at '<!DOCTYPE html>
  "https://helsing.ai/jobs/4212864101?gh_jid=4212864101",
  "https://bolt.eu/en/careers/positions/6989975002",
  "https://careers.datadoghq.com/detail/4452892",
  "https://jobs.elastic.co/form?gh_jid=5518454",
  "https://ripple.com/careers/all-jobs/job/5144512",
  "https://www.hubspot.com/careers/jobs/5402223",
  "https://www.mongodb.com/careers/jobs/5424409",
  "https://www.noredink.com/job_post?gh_jid=5586486",
  "https://www.onemedical.com/careers/all-departments/5433427",
  "https://ripple.com/careers/all-jobs/job/5558121/",
  "https://stability.ai/careers?gh_jid=4246271101",
  "https://www.sumup.com/careers/positions/london-united-kingdom/engineering/engineering-manager-mobile-global-bank/6970735002",
  "https://tipalti.com/careers/jobs/?gh_jid=5029634004",
  "https://business.trustpilot.com/jobs/5555044",
  "https://www.westmonroe.com/careers/job-search/apply?gh_jid=5043104004",
  "https://www.zilch.com/uk/job/?gh_jid=5045377004",
  "https://www.zwift.com/uk/careers?gh_jid=7056412002#grnhse-job-details",
]

# TODO: Handle embedded job postings on Greenhouse

# -----------------
# Rails Jobs
# -----------------

rails_job_urls = [
  "https://boards.greenhouse.io/cleoai/jobs/4628944002", # greenhouse # senior"
  "https://boards.greenhouse.io/ably30/jobs/4229668101", # greenhouse # senior
  # "https://apply.workable.com/papier/j/F2D67EF125/", # workable # seniors
  # "https://apply.workable.com/builderai/j/D157ED0496/", # workable # mid
  # # "https://apply.workable.com/api/v1/accounts/papier/jobs/F2D67EF125?details=true" # alternative url to test
  # "https://apply.workable.com/builderai/j/E417F55824/", # workable # senior
  # # "https://jobs.lever.co/zeneducate/e02e26bc-dd34-477b-a3e7-612c9422dccd", # lever # senior # no longer live
  # "https://jobs.lever.co/zeneducate/3422d04b-963a-4cc7-91e0-85ee315c2007", # lever # senior
  # "https://jobs.smartrecruiters.com/Billetto/80023032-backend-web-developer", # smartrecruiters # mid
  # "https://jobs.smartrecruiters.com/Canva/743999942402703", # smartrecruiters # senior
  # "https://www.totaljobs.com/job/101793572/apply", # totaljobs # senior
  # "https://www.totaljobs.com/job/junior-software-developer/sparta-global-limited-job101695431", # totaljobs # junior
  # "https://www.totaljobs.com/job/full-stack-ruby-on-rails-developer/movement-8-job101778422", # totaljobs # mid
  # "https://www.simplyhired.co.uk/job/K0OD6J_mQAkEV2xH5ktIzSbCDjCzpj7yYtGh9w6TiCyPLg2dLaALPw", # simplyhired # mid # create account # expired
  # "https://www.simplyhired.co.uk/job/n26j_p5HaCBjI8iYuRBBTL9sUQFIfUhIi-w-sZeuRh3HY0YWtIHqpg", # simplyhired # mid # create account # expired
  # "https://www.simplyhired.co.uk/job/3eJ7KIbUJzmvyGwP8nYZQOn-AYcUkLk7jDAofeTImguEW-OQ0dlh3g", # simplyhired # mid # create account # expired
  # "https://uk.indeed.com/viewjob?jk=36cda28dd190bc72", # indeed # senior
  # "https://www.linkedin.com/jobs/view/ruby-on-rails-2-hands-on-engineering-manager-lead-developer-london-twice-a-week-up-to-%C2%A3100-000-offers-sponsorship-at-opus-recruitment-solutions-3756503864/", # linkedin # senior
  # "https://www.linkedin.com/jobs/view/3799028903/", # linkedin # mid
  # "https://www.linkedin.com/jobs/view/fullstack-ruby-on-rails-developer-at-movement8-3798307820/", # linkedin # mid
  # "https://www.reed.co.uk/jobs/junior-software-developer-ruby-on-rails/51872078", # reed # junior
  # "https://careers.judge.me/jobs/t7THEE3YAvBh/fullstack-ruby-on-rails-developer", # freshteam # mid
  # "https://www.oho.co.uk/job-details/?id=mid-level-ruby-on-rails-developer-876454", # oho # mid
  # "https://alphasights.hire.trakstar.com/jobs/fk0zzt/", # trakstar # mid
  # "https://www.aplitrak.com/?adid=bWF4bS41NzI2Mi41NDAzQG5vaXJjb25zdWx0aW5nLmFwbGl0cmFrLmNvbQ", # aplitrak # mid # create account
  # "https://www.recruit.net/job/ruby-on-rails-developer-jobs/F02F2507F39B18DD", # recruit.net # mid # create account
  # "https://5ivetech.co.uk/apply-job/?job_id=ODU5NDI=", # 5ivetech # mid
  # "https://www.internwise.co.uk/job/33389/ruby-on-rails-developer-internship", # internwise # intern
  # "https://www.robertwalters.co.uk/technologydigital/jobs/softwaredevelopmentengineering/1705516-fullstack-developer-12month.html", # robertwalters # mid # create account
  # "https://sittercity.applytojob.com/apply/bVigxNJAWt/Engineering-Manager-Sitter-Engagement", # jazzhr # mid
]

# -----------------
# Consulting Jobs
# -----------------

consulting_job_urls = [
  "https://bambusdev.my.site.com/s/details?jobReq=Fixed-Income-Quantitative-Analyst-%E2%80%93-Macro---Commodities-Investment-Teams-_REQ5179",
  "https://baringa.csod.com/ux/ats/careersite/4/home/requisition/1369?c=baringa", # expired
  "https://barings.wd1.myworkdayjobs.com/en-US/Barings/job/London-United-Kingdom/Barings-Investment-Management-Summer-Internship_JR_004872",
  "https://bnymellon.eightfold.ai/careers?pid=17632073&domain=bnymellon.com",
  "https://boards.greenhouse.io/embed/job_app?for=charlesriverassociates&token=5395642",
  "https://careers.accuracy.com/",
  "https://careers.ardian.com/en-GB/jobs/2455619-legal-intern",
  "https://careers.bdo.co.uk/job/birmingham/2024-summer-internship-programme/1469/6522969600",
  "https://careers.lcp.com/search-all-vacancies/job-vacancy?id=219839",
  "https://careers.marshmclennan.com/eu/en/apply?jobSeqNo=MAMCGLOBALR249605EXTERNALENGLOBAL&step=1",
  "https://careers.occstrategy.com/vacancies/243/graduate-summer-internship-2024-london-office.html",
  "https://cdpq.wd10.myworkdayjobs.com/en-US/CDPQ-recrutement-universitaire/job/Intern--Private-Equity_R02982?locations=1ae8f3a46c3f01272bab23d7d109ab10",
  "https://cerberus.wd1.myworkdayjobs.com/en-US/CerberusCareers/job/London-United-Kingdom/XMLNAME-2024-UK-Summer-CES-Asset-Management-Internship_R1172?locations=220ccf21815501decd9e5d469507c05f",
  "https://cerberus.wd1.myworkdayjobs.com/en-US/CerberusCareers/job/London-United-Kingdom/XMLNAME-2024-UK-Summer-Legal---Compliance-Internship_R1177",
  "https://dws.groupgti.com/2024-dws-internship---investment-division---uk/19/viewdetails",
  "https://fticonsult.referrals.selectminds.com/ftistudentcareers/jobs/2024-summer-internship-economic-financial-consulting-17434",
  "https://goldmansachs.tal.net/vx/lang-en-GB/mobile-0/brand-2/xf-d5711d1afb50/candidate/register",
  "https://groupecreditagricole.jobs/en/apply-without-account/summer-internship-programme-2024---legal-department-reference--2023-83705--/",
  "https://hymans.current-vacancies.com/Jobs/Advert/3264996?cid=2054&t=Summer-Internship-Programme",
  "https://jobs.gartner.com/jobs/job/79739-european-consulting-internship-summer-2024-masters-2025-graduates-multiple-locations?source=UNV-10349",
  "https://jobs.natwestgroup.com/jobs/13295700-internal-audit-risk-internship",
  "https://jobs.pwc.co.uk/student/uk/en/apply?jobSeqNo=PUDPUNUK473968WDEXTERNALENUK&step=1",
  "https://jobs.smartrecruiters.com/LegalAndGeneral/743999949816273-investment-summer-internship-2024?trid=4556ca14-794c-4023-bd62-6813e288177e",
  "https://jobs.smartrecruiters.com/Verisk/743999946517680-consulting-intern",
  "https://kornferry.tal.net/vx/appcentre-ext/brand-4/spa-1/candidate/so/pm/1/pl/2/opp/15717-Summer-2024-Internship-London/en-GB",
  "https://lek.tal.net/vx/lang-en-GB/mobile-0/appcentre-1/brand-2/candidate/so/pm/1/pl/1/opp/3343-Summer-Associate-London-Office-2024/en-GB",
  "https://mavenswood.freshteam.com/jobs/coz0TIxB5MVS/private-equity-analyst",
  "https://moelis-careers.tal.net/vx/lang-en-GB/mobile-0/appcentre-1/brand-4/user-7/xf-807238d10272/wid-2/candidate/so/pm/1/pl/2/opp/36-2024-Summer-Analyst-Investment-Banking-London/en-GB",
  "https://mufgub.wd3.myworkdayjobs.com/en-US/MUFG-Careers/job/London/MUFG-2024-UK-Coverage---Investment-Banking-Summer-Internship_10061826-WD-1",
  "https://nb.wd1.myworkdayjobs.com/en-US/nbcareers/job/London/Intern_R0008830?locations=7bfa81f3f1a101929a3b77afc3985976&locations=0c6af06679b4012c714901a28e49b060",
  "https://rbccmgraduates.gtisolutions.co.uk/2024summer-analyst---global-investment-banking/255/viewdetails",
  "https://rbccmgraduates.gtisolutions.co.uk/2024summer-analystcorporate-banking/260/viewdetails",
  "https://seagatecareers.com/job/DerryLondonderry-Legal-Summer-Intern-%28EMEA%29/1104871300/",
  "https://trkr.app/vacancy/finance-intern-2024/",
  "https://www.coventrycareers.co.uk/vacancies/7603/graduate-internship--legal-risk--control-legal-counsel.html",
  "https://www.mckinsey.com/careers/search-jobs/jobs/associateintern-14918",
  "https://www.verition.com/open-positions?gh_jid=4041599007&gh_src=f2276b3d7us",
  "https://www.werkenbijabnamro.nl/en/vacancy/5964/internship-programme-2024-uk-legal#vacancy-application-form"
]


# -----------------
# Software Engineering Jobs
# -----------------

soft_eng_job_urls = [
  "https://careers.justeattakeaway.com/global/en/apply?jobSeqNo=TAKEGLOBALR035518ENGLOBAL&step=1", # phenom # requires full scrape
  "https://moonpay.wd1.myworkdayjobs.com/GTI/job/London-United-Kingdom/Full-Stack-Engineer_JR100014", # workday # not public
]

# -----------------
# Workable ATS
# -----------------

workable_job_urls = [
  "https://apply.workable.com/starling-bank/j/7F5B223D0D/",
  "https://apply.workable.com/vira-health/j/D60B851C7C/",
]

# -----------------
# Lever ATS
# -----------------

lever_job_urls = [
  "https://jobs.lever.co/quantcast/30055553-6f06-4d54-ae63-bc474009754c",
  "https://jobs.lever.co/cloudwalk/657c121e-99f4-48e9-9fdf-4b0b37fefcf8",
]

# -----------------
# SmartRecruiters ATS
# -----------------

smartrecruiters_job_urls = [
  "https://jobs.smartrecruiters.com/SSENSE1/743999955472143",
]

# -----------------
# Ashby ATS
# -----------------

ashby_job_urls = [
  "https://jobs.ashbyhq.com/lilt/b1448632-738b-4de8-9991-06f32bb16bf1", # expired
  "https://jobs.ashbyhq.com/beamery/b4c4f8e7-e6cc-423b-8b8d-bb05c1ab050e", # expired
  "https://jobs.ashbyhq.com/lilt/1f2aeca1-098f-42ee-a68a-37f824b6779f",
  "https://jobs.ashbyhq.com/beamery/44ff9937-f026-467d-b8dc-935c49f22b52",
]

# -----------------
# Workday ATS
# -----------------

workday_job_urls = [
  "https://www.accenture.com/gb-en/careers/jobdetails?id=R00190006_en&title=SAP%20Supply%20Chain%20Senior%20Manager",
  "https://moonpay.wd1.myworkdayjobs.com/GTI/job/London-United-Kingdom/Full-Stack-Engineer_JR100014",
]

# -----------------
# Tal.net ATS
# -----------------

tal_site_urls = [
  "https://fco.tal.net/candidate",
  "https://justicejobs.tal.net/candidate",
  "https://homeofficejobs.tal.net/candidate",
  "https://theroyalhousehold.tal.net/candidate",
  "https://housesofparliament.tal.net/candidate",
  "https://environmentagencyjobs.tal.net/candidate",
  "https://policecareers.tal.net/candidate",
  "https://thamesvalleypolice.tal.net/candidate",
  "https://ual.tal.net/candidate/",
]

gov_uk_site_urls = [
  "https://www.civilservicejobs.service.gov.uk/csr/index.cgi",
  "https://jobs.justice.gov.uk/",
  "https://careers.homeoffice.gov.uk/",
  "https://www.jobs.nhs.uk/candidate",
]

tal_job_urls = [
  "https://kornferry.tal.net/vx/lang-en-GB/mobile-0/appcentre-1/brand-4/user-72902/xf-eeb733132400/candidate/so/pm/1/pl/2/opp/15864-Digital-Delivery-Total-Rewards-Intern-Analyst-1-Year-Contract/en-GB",
]

# -----------------
# Ambertrack ATS
# -----------------

ambertrack_site_urls = [
  "https://eycareers.ambertrack.global/studentrecruitment2024/candidatelogin.aspx?cookieCheck=true",
  "https://networkrailcandidate.ambertrack.global/apprenticeshipsspring2022/Login.aspx?cookieCheck=true",
  "https://kentgraduates.ambertrack.co.uk/kentgraduates2024/CandidateLogin.aspx?e=401&cookieCheck=true",
  "https://atkinscandidate.ambertrack.co.uk/graduates2023/login.aspx?cookieCheck=true",
]

# -----------------
# Freshteam ATS
# -----------------

# https://#{company}.freshteam.com/api/job_postings # requires authentication

# -----------------
# Phenom ATS
# -----------------

# https://api.phenom.com/ # requires authentication
# https://api.phenompeople.com/ # requires authentication

# -----------------
# PinpointHQ ATS
# -----------------

pinpointhq_job_urls = [
  "https://field.pinpointhq.com/en/postings/6b079493-f5ed-42d5-b78a-acbf97985521",
]

# -----------------
# Screenloop ATS
# -----------------

# screenloop_job_urls = [
#   "https://app.screenloop.com/careers/atlast/job_posts/122",
# ]

# -----------------
# BambooHR ATS
# -----------------

bamboohr_job_urls = [
  "https://gravyanalytics.bamboohr.com/careers/51",
  "https://avidbots.bamboohr.com/careers/750",
]

# -----------------
# Recruitee ATS
# -----------------

recruitee_job_urls = [
  "https://yays.recruitee.com/o/acquisition-development-intern-amsterdam",
]

# -----------------
# Manatal ATS
# -----------------

manatal_job_urls = [
  "https://www.careers-page.com/ptc-group/job/L775X55X",
]


# -----------------
# Other ATS
# -----------------

other_ats_job_urls = [
  "https://nucamp.breezy.hr/p/ac8a9f22ce28-cybersecurity-fundamentals-teaching-assistant-coding-instructor-online-central-timezone/apply", # requires authentication
  "https://jobs.bettyblocks.com/o/full-stack-developer-2-3", # recruitee # frequent redirects
  "https://baringa.csod.com/ux/ats/careersite/4/home/requisition/1474?c=baringa",
  "https://careers.pageuppeople.com/754/ci/en/job/496892/store-manager", # pageuppeople
  "https://krb-sjobs.brassring.com/tgnewui/search/home/home?partnerid=26059&siteid=5016#jobDetails=704679_5016", # brassring
  "https://dws.groupgti.com/Account/Register?ReturnUrl=%2F2024-dws-graduate-program-pace--client-coverage-division---us%2F23%2Fapply", # groupgti
]

# -----------------
# Company-specific
# -----------------

comp_specific_job_urls = [
  "https://jobs.apple.com/en-us/details/200525781/network-engineer-internship-apple-is-t",
  "https://careers.tiktok.com/position/7298315322230229257/detail",
]

# -----------------
#  ATS
# -----------------

# _job_urls = [
#   "",
# ]

# job_urls = [greenhouse_job_urls, workable_job_urls, lever_job_urls, smartrecruiters_job_urls, ashby_job_urls]

defunct_urls = []
unprocessed_job_urls = {}

# Uncomment next line if you prefer to seed with hardcoded urls:
# (rails_job_urls + greenhouse_job_urls).each do |url|

jobs_to_seed.each do |url|
  company, ats_job_id = CompanyCreator.new(url).find_or_create_company
  p "CompanyCreator complete: #{company.company_name}"

  job = Job.create(
    job_title: "Job Title Placeholder",
    job_posting_url: url,
    company_id: company.id,
    applicant_tracking_system_id: company.applicant_tracking_system_id,
    ats_job_id: ats_job_id,
  )

  next unless job.id

  if JobCreator.new(job).check_job_is_live
    if JobCreator.new(job).find_or_create_job
      company.total_live += 1
      p "Created job - #{Job.last.job_title}"
    else
      p "Failed to create job"
      job.destroy
      defunct_urls << job.job_posting_url
    end
  else
    p "Job posting is no longer live"
    job.destroy
    defunct_urls << job.job_posting_url
  end
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

# PgSearch::Multisearch.rebuild(Job)
# PgSearch::Multisearch.rebuild(Company)
