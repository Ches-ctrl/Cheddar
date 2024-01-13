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
  { name: "Greenhouse",
    website_url: "https://greenhouse.io/",
    base_url_main: "https://boards.greenhouse.io/",
    base_url_api: "https://boards-api.greenhouse.io/v1/boards/"
  },
  { name: "Workable",
    website_url: "https://workable.com/",
    all_jobs_url: "https://jobs.workable.com/",
    base_url_main: "https://apply.workable.com/",
    base_url_api: "https://apply.workable.com/api/v1/accounts/"
  },
  { name: "Lever",
    website_url: "https://lever.co/",
    base_url_main: "https://jobs.lever.co/",
    base_url_api: "https://api.lever.co/v0/postings/"
  },
  { name: "SmartRecruiters",
    website_url: "https://smartrecruiters.com/",
    all_jobs_url: "https://jobs.smartrecruiters.com/",
    base_url_main: "https://jobs.smartrecruiters.com/",
    base_url_api: "https://api.smartrecruiters.com/v1/companies/"
  },
  { name: "Ashby",
    website_url: "https://ashbyhq.com/",
    base_url_main: "https://jobs.ashbyhq.com/",
    base_url_api: "https://api.ashbyhq.com/posting-api/job-board/"
  },
  { name: "Workday",
    website_url: "https://www.workday.com/",
    base_url_main: "https://XXX.wd1.myworkdayjobs.com/en-US/GTI"
  },
  { name: "Tal.net",
    website_url: "https://tal.net/",
    all_jobs_url: "https://XXX.tal.net/candidate"
  },
  { name: "TotalJobs",
    website_url: "https://www.totaljobs.com/"
  },
  { name: "Simplyhired",
    website_url: "https://www.simplyhired.co.uk/"
  },
  { name: "Jobvite",
    website_url: "https://jobvite.com/"
  },
  { name: "Taleo",
    website_url: "https://taleo.com/"
  },
  { name: "Ambertrack",
    website_url: "https://ambertrack.com/"
  },
]

# Tal.net clients: FCO, Houses of Parliament, Police

ats_data.each do |ats|
  ApplicantTrackingSystem.create(ats)
  puts "Created ATS - #{ApplicantTrackingSystem.last.name}"
end

puts "Created #{ApplicantTrackingSystem.count} ATSs"

puts "-------------------------------------"

# TODO: Remove ATS formats from seeds and schema - no longer required

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

greenhouse_job_urls = [
  "https://boards.greenhouse.io/11fs/jobs/4266126101",
  "https://boards.greenhouse.io/ambientai/jobs/4301104006",
  "https://boards.greenhouse.io/bcgdv/jobs/6879714002",
  "https://boards.greenhouse.io/clearscoretechnologylimited/jobs/4269717101",
  "https://boards.greenhouse.io/cleoai/jobs/5033034002",
  "https://boards.greenhouse.io/cloudflare/jobs/5533430",
  "https://boards.greenhouse.io/codepath/jobs/4035988007",
  "https://boards.greenhouse.io/codepath/jobs/4059099007",
  "https://boards.greenhouse.io/codepath/jobs/4141438007",
  "https://boards.greenhouse.io/copperco/jobs/4243269101",
  "https://boards.greenhouse.io/coreweave/jobs/4241710006",
  "https://boards.greenhouse.io/css/jobs/6975614002",
  "https://boards.greenhouse.io/cultureamp/jobs/5496553",
  "https://boards.greenhouse.io/cultureamp/jobs/5538191",
  "https://boards.greenhouse.io/dataiku/jobs/5043269004",
  "https://boards.greenhouse.io/deliveroo/jobs/5094403",
  "https://boards.greenhouse.io/deliveroo/jobs/5447359",
  "https://boards.greenhouse.io/doctolib/jobs/5811790003",
  "https://boards.greenhouse.io/doctolib/jobs/5828747003",
  "https://boards.greenhouse.io/drweng/jobs/5345753",
  "https://boards.greenhouse.io/elementalexcelerator/jobs/5027131004",
  "https://boards.greenhouse.io/epicgames/jobs/4969053004",
  "https://boards.greenhouse.io/featurespace/jobs/5472209",
  "https://boards.greenhouse.io/figma/jobs/5039807004",
  "https://boards.greenhouse.io/forter/jobs/6889370002",
  "https://boards.greenhouse.io/gemini/jobs/5203656",
  "https://boards.greenhouse.io/geniussports/jobs/5693417003",
  "https://boards.greenhouse.io/getir/jobs/4258936101",
  "https://boards.greenhouse.io/globalwebindex/jobs/6940363002",
  "https://boards.greenhouse.io/gomotive/jobs/7025455002",
  "https://boards.greenhouse.io/gomotive/jobs/7030195002",
  "https://boards.greenhouse.io/grammarly/jobs/5523286",
  "https://boards.greenhouse.io/gusto/jobs/5535268",
  "https://boards.greenhouse.io/halcyon/jobs/4891571004",
  "https://boards.greenhouse.io/helsing/jobs/4129902101",
  "https://boards.greenhouse.io/intercom/jobs/4763765",
  "https://boards.greenhouse.io/inyova/jobs/5042265004",
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
  "https://boards.greenhouse.io/openai/jobs/4907945004",
  "https://boards.greenhouse.io/opendoor/jobs/4255190006",
  "https://boards.greenhouse.io/opentable/jobs/7083964002",
  "https://boards.greenhouse.io/neo4j/jobs/4309978006",
  "https://boards.greenhouse.io/phonepe/jobs/5816286003",
  "https://boards.greenhouse.io/point72/jobs/7061105002",
  "https://boards.greenhouse.io/prolific/jobs/4272099101",
  "https://boards.greenhouse.io/relativity/jobs/6916371002",
  "https://boards.greenhouse.io/remotecom/jobs/5756728003",
  "https://boards.greenhouse.io/samsara/jobs/5580492",
  "https://boards.greenhouse.io/settle/jobs/4350962005",
  # "https://boards.eu.greenhouse.io/speechmatics/jobs/4261341101",
  "https://boards.greenhouse.io/springhealth66/jobs/4336742005",
  "https://boards.greenhouse.io/stenn/jobs/4262887101",
  "https://boards.greenhouse.io/superpayments/jobs/4271055101",
  "https://boards.greenhouse.io/synack/jobs/5469197",
  "https://boards.greenhouse.io/synthesia/jobs/4250474101",
  "https://boards.greenhouse.io/talos/jobs/5040783004",
  "https://boards.greenhouse.io/teads/jobs/5529600",
  "https://boards.greenhouse.io/tenstorrent/jobs/4120628007",
  "https://boards.greenhouse.io/transferwise/jobs/5479877",
  "https://boards.greenhouse.io/watershedclimate/jobs/4698719004",
  "https://boards.greenhouse.io/workato/jobs/7016061002",
  "https://boards.greenhouse.io/zscaler/jobs/4092460007",
]

greenhouse_job_urls_embedded = [
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
  "https://boards.greenhouse.io/algolia/jobs/4989661004", # greenhouse # junior
  "https://apply.workable.com/papier/j/F2D67EF125/", # workable # senior
  "https://apply.workable.com/builderai/j/D157ED0496/", # workable # mid
  "https://apply.workable.com/builderai/j/E417F55824/", # workable # senior
  "https://jobs.lever.co/zeneducate/e02e26bc-dd34-477b-a3e7-612c9422dccd", # lever # senior
  "https://jobs.lever.co/zeneducate/3422d04b-963a-4cc7-91e0-85ee315c2007", # lever # senior
  "https://jobs.smartrecruiters.com/Billetto/80023032-backend-web-developer", # smartrecruiters # mid
  "https://jobs.smartrecruiters.com/Canva/743999942402703", # smartrecruiters # senior
  "https://www.totaljobs.com/job/101793572/apply", # totaljobs # senior
  "https://www.totaljobs.com/job/junior-software-developer/sparta-global-limited-job101695431", # totaljobs # junior
  "https://www.totaljobs.com/job/full-stack-ruby-on-rails-developer/movement-8-job101778422", # totaljobs # mid
  "https://www.simplyhired.co.uk/job/K0OD6J_mQAkEV2xH5ktIzSbCDjCzpj7yYtGh9w6TiCyPLg2dLaALPw", # simplyhired # mid # create account
  "https://www.simplyhired.co.uk/job/n26j_p5HaCBjI8iYuRBBTL9sUQFIfUhIi-w-sZeuRh3HY0YWtIHqpg", # simplyhired # mid # create account
  "https://www.simplyhired.co.uk/job/3eJ7KIbUJzmvyGwP8nYZQOn-AYcUkLk7jDAofeTImguEW-OQ0dlh3g", # simplyhired # mid # create account
  "https://uk.indeed.com/viewjob?jk=36cda28dd190bc72", # indeed # senior
  "https://www.linkedin.com/jobs/view/ruby-on-rails-2-hands-on-engineering-manager-lead-developer-london-twice-a-week-up-to-%C2%A3100-000-offers-sponsorship-at-opus-recruitment-solutions-3756503864/", # linkedin # senior
  "https://www.linkedin.com/jobs/view/3799028903/", # linkedin # mid
  "https://www.linkedin.com/jobs/view/fullstack-ruby-on-rails-developer-at-movement8-3798307820/", # linkedin # mid
  "https://www.reed.co.uk/jobs/junior-software-developer-ruby-on-rails/51872078", # reed # junior
  "https://careers.judge.me/jobs/t7THEE3YAvBh/fullstack-ruby-on-rails-developer", # freshteam # mid
  "https://www.oho.co.uk/job-details/?id=mid-level-ruby-on-rails-developer-876454", # oho # mid
  "https://alphasights.hire.trakstar.com/jobs/fk0zzt/", # trakstar # mid
  "https://www.aplitrak.com/?adid=bWF4bS41NzI2Mi41NDAzQG5vaXJjb25zdWx0aW5nLmFwbGl0cmFrLmNvbQ", # aplitrak # mid # create account
  "https://www.recruit.net/job/ruby-on-rails-developer-jobs/F02F2507F39B18DD", # recruit.net # mid # create account
  "https://5ivetech.co.uk/apply-job/?job_id=ODU5NDI=", # 5ivetech # mid
  "https://www.internwise.co.uk/job/33389/ruby-on-rails-developer-internship", # internwise # intern
  "https://www.robertwalters.co.uk/technologydigital/jobs/softwaredevelopmentengineering/1705516-fullstack-developer-12month.html", # robertwalters # mid # create account
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

# https://workable.readme.io/reference/generate-an-access-token
# https://apply.workable.com/api/v1/widget/accounts/#{company_id}
# https://www.workable.com/api/accounts/#{company_id}/locations
# https://www.workable.com/api/accounts/#{company_id}/departments

workable_job_urls = [
  "https://apply.workable.com/starling-bank/j/7F5B223D0D/",
  "https://apply.workable.com/vira-health/j/D60B851C7C/",
  # "https://apply.workable.com/papier/j/F2D67EF125/",
]

# -----------------
# Lever ATS
# -----------------

# https://api.lever.co/v0/postings/#{company_id} # gives links to list of jobs (not JSON)
# https://api.lever.co/v0/postings/#{company_id}?mode=json # can also do HTML and iframe
# https://api.lever.co/v0/postings/#{company_id}/#{job_id}

lever_job_urls = [
  "https://jobs.lever.co/quantcast/30055553-6f06-4d54-ae63-bc474009754c",
  # "https://jobs.lever.co/zeneducate/e02e26bc-dd34-477b-a3e7-612c9422dccd", # lever # senior
  # "https://jobs.lever.co/zeneducate/3422d04b-963a-4cc7-91e0-85ee315c2007", # lever # senior
  "https://jobs.lever.co/cloudwalk/657c121e-99f4-48e9-9fdf-4b0b37fefcf8",
]

# -----------------
# SmartRecruiters ATS
# -----------------

# https://developers.smartrecruiters.com/docs/the-smartrecruiters-platform
# https://api.smartrecruiters.com/v1/companies/#{company_id}/postings
# https://api.smartrecruiters.com/v1/companies/#{company_id}/postings/#{job_id}

smartrecruiters_job_urls = [
  "https://jobs.smartrecruiters.com/SSENSE1/743999955472143",
]

# -----------------
# Ashby ATS
# -----------------

# https://developers.ashbyhq.com/docs/public-job-posting-api
# https://api.ashbyhq.com/posting-api/job-board/{JOB_BOARD_NAME}?includeCompensation=true
# Individual listings - N/A

ashby_job_urls = [
  "https://jobs.ashbyhq.com/lilt/b1448632-738b-4de8-9991-06f32bb16bf1",
  "https://jobs.ashbyhq.com/beamery/b4c4f8e7-e6cc-423b-8b8d-bb05c1ab050e",
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


# -----------------
# Freshteam ATS
# -----------------

# https://#{company}.freshteam.com/api/job_postings # requires authentication

freshteam_job_urls = [
  "",
]

# -----------------
# Phenom ATS
# -----------------

# https://api.phenom.com/ # requires authentication
# https://api.phenompeople.com/ # requires authentication

phenom_job_urls = [
  "",
]

# -----------------
# Company-specific
# -----------------

comp_specific_job_urls = [
  "https://jobs.apple.com/en-us/details/200525781/network-engineer-internship-apple-is-t",
  "https://careers.tiktok.com/position/7298315322230229257/detail",
]

# -----------------
# Taleo ATS
# -----------------

# taleo_job_urls = [
#   "",
# ]

# -----------------
# Breezy HR ATS
# -----------------

# breezyhr_job_urls = [
#   "",
# ]

# -----------------
# Bamboo HR ATS
# -----------------

# bamboohr_job_urls = [
#   "",
# ]

# -----------------
# Jobvite ATS
# -----------------

# jobvite_job_urls = [
#   "",
# ]

# -----------------
#  ATS
# -----------------

# _job_urls = [
#   "",
# ]

# job_urls = [greenhouse_job_urls, workable_job_urls, lever_job_urls, smartrecruiters_job_urls, ashby_job_urls]

# TODO: Collect additional company postings functionality
# TODO: Add jobs from all ATS systems

greenhouse_job_urls.each do |url|
  company = CompanyCreator.new(url).find_or_create_company
  p "CompanyCreator complete: #{company.company_name}"

  job = Job.create!(
    job_title: "Job Title Placeholder",
    job_posting_url: url,
    company_id: company.id,
  )

  p "Job posting url: #{job.job_posting_url}"

  JobCreator.new(job).add_job_details
  p "Created job - #{Job.last.job_title}"
end

puts "Created #{greenhouse_job_urls.count} jobs based on the provided URLs."

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
