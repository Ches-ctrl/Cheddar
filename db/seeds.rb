# ------------
# Instructions
# ------------

# Part I
# 1. Remove all duplicate jobs
# 2. Put jobs in alphabetical order (in the New Seed File Section, taking from the Old Seed File Section)
# 3. Add the application_criteria and application_details hashes to all jobs (it is currently missing from many of them)
# 4. Fill in the application_criteria hash by inspecting the job application form via the job_posting_url
# 5. Similarly, fill in the application_details hash by inspecting the job application form via the job_posting_url
# 6. NB. Each element in each hash must be uniquely identifiable by the scraper

# Part II
# 7. Add 5 additional jobs for each ATS: Taleo, Workday, Ambertrack, Tal.net, SmartRecruiters, Ashby
# 8. NB. Jobs must be from: https://www.trueup.io/
# 8. Repeat the process completed in Part I

puts "Deleting previous (1) users, (2) jobs, (3)companies, (4) ATS Formats and (5) Applicant Tracking Systems..."

puts "-------------------------------------"

User.destroy_all
Job.destroy_all
Company.destroy_all
AtsFormat.destroy_all
ApplicantTrackingSystem.destroy_all

puts "Creating new Applicant Tracking Systems..."

ApplicantTrackingSystem.create(
  name: "Workable",
  website_url: "https://workable.com/",
)

puts "Created ATS - #{ApplicantTrackingSystem.last.name}"

ApplicantTrackingSystem.create(
  name: "Greenhouse",
  website_url: "https://greenhouse.io/",
)

puts "Created ATS - #{ApplicantTrackingSystem.last.name}"

ApplicantTrackingSystem.create(
  name: "Lever",
  website_url: "https://lever.co/",
)

puts "Created ATS - #{ApplicantTrackingSystem.last.name}"

ApplicantTrackingSystem.create(
  name: "Jobvite",
  website_url: "https://jobvite.com/",
)

puts "Created ATS - #{ApplicantTrackingSystem.last.name}"

ApplicantTrackingSystem.create(
  name: "SmartRecruiters",
  website_url: "https://smartrecruiters.com/",
)

ApplicantTrackingSystem.create(
  name: "Taleo",
  website_url: "https://taleo.com/",
)

puts "Created ATS - #{ApplicantTrackingSystem.last.name}"

ApplicantTrackingSystem.create(
  name: "Workday",
  website_url: "https://workday.com/",
)

puts "Created ATS - #{ApplicantTrackingSystem.last.name}"

ApplicantTrackingSystem.create(
  name: "Ambertrack",
  website_url: "https://ambertrack.com/",
)

puts "Created ATS - #{ApplicantTrackingSystem.last.name}"

ApplicantTrackingSystem.create(
  name: "Tal.net",
  website_url: "https://tal.net/",
)

puts "Created ATS - #{ApplicantTrackingSystem.last.name}"

ApplicantTrackingSystem.create(
  name: "Ashby",
  website_url: "https://ashbyhq.com/",
)

puts "Created ATS - #{ApplicantTrackingSystem.last.name}"

puts "Created #{ApplicantTrackingSystem.count} ATSs"

puts "-------------------------------------"

puts "Creating new ATS formats..."

AtsFormat.create(
  name: "Workable_1",
  applicant_tracking_system_id: ApplicantTrackingSystem.find_by(name: 'Workable').id,
)

puts "Created ATS format - #{AtsFormat.last.name}"

AtsFormat.create(
  name: "Workable_2",
  applicant_tracking_system_id: ApplicantTrackingSystem.find_by(name: 'Workable').id,
)

puts "Created ATS format - #{AtsFormat.last.name}"

AtsFormat.create(
  name: "Greenhouse_1",
  applicant_tracking_system_id: ApplicantTrackingSystem.find_by(name: 'Greenhouse').id,
)

puts "Created ATS format - #{AtsFormat.last.name}"

AtsFormat.create(
  name: "Greenhouse_2",
  applicant_tracking_system_id: ApplicantTrackingSystem.find_by(name: 'Greenhouse').id,
)

puts "Created ATS format - #{AtsFormat.last.name}"

AtsFormat.create(
  name: "Lever_1",
  applicant_tracking_system_id: ApplicantTrackingSystem.find_by(name: 'Lever').id,
)

puts "Created ATS format - #{AtsFormat.last.name}"

AtsFormat.create(
  name: "Jobvite_1",
  applicant_tracking_system_id: ApplicantTrackingSystem.find_by(name: 'Jobvite').id,
)

puts "Created ATS format - #{AtsFormat.last.name}"

AtsFormat.create(
  name: "SmartRecruiters_1",
  applicant_tracking_system_id: ApplicantTrackingSystem.find_by(name: 'SmartRecruiters').id,
)

puts "Created ATS format - #{AtsFormat.last.name}"

AtsFormat.create(
  name: "Taleo_1",
  applicant_tracking_system_id: ApplicantTrackingSystem.find_by(name: 'Taleo').id,
)

puts "Created ATS format - #{AtsFormat.last.name}"

AtsFormat.create(
  name: "Workday_1",
  applicant_tracking_system_id: ApplicantTrackingSystem.find_by(name: 'Workday').id,
)

puts "Created ATS format - #{AtsFormat.last.name}"

AtsFormat.create(
  name: "Ambertrack_1",
  applicant_tracking_system_id: ApplicantTrackingSystem.find_by(name: 'Ambertrack').id,
)

puts "Created ATS format - #{AtsFormat.last.name}"

AtsFormat.create(
  name: "Tal.net_1",
  applicant_tracking_system_id: ApplicantTrackingSystem.find_by(name: 'Tal.net').id,
)

puts "Created ATS format - #{AtsFormat.last.name}"

AtsFormat.create(
  name: "Ashby_1",
  applicant_tracking_system_id: ApplicantTrackingSystem.find_by(name: 'Ashby').id,
)

puts "Created ATS format - #{AtsFormat.last.name}"

puts "Created #{AtsFormat.count} ATS formats"

puts "-------------------------------------"

puts "Creating new companies..."

Company.create(
  company_name: "Kroo",
  company_category: "Tech",
  company_website_url: "https://kroo.com/"
)

  puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "Deliveroo",
  company_category: "Tech",
  company_website_url: "https://deliveroo.co.uk/"
)

  puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "BCG Digital Ventures",
  company_category: "Tech",
  company_website_url: "https://bcgdv.com/"
)

puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "Cleo",
  company_category: "FinTech",
  company_website_url: "https://web.meetcleo.com/"
)

puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "BrainStation",
  company_category: "Tech",
  company_website_url: "https://brainstation.io/"
)

Company.create(
  company_name: "Blink",
  company_category: "Tech",
  company_website_url: "https://www.joinblink.com/"
)

puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "Builder.ai",
  company_category: "Tech",
  company_website_url: "https://www.builder.ai/"
)

puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "9fin",
  company_category: "Tech",
  company_website_url: "https://9fin.com/"
)

puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "Quantexa",
  company_category: "Tech",
  company_website_url: "https://www.quantexa.com/"
)

  puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "Apple Inc",
  company_category: "Tech",
  company_website_url: "https://apple.com/uk")

  puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "Google",
  company_category: "Tech",
  company_website_url: "https://google.com/")

  puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "Meta",
  company_category: "Tech",
  company_website_url: "https://meta.com/")

  puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "Amazon Web Services",
  company_category: "Tech",
  company_website_url: "https://aws.com/")

  puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "Netflix",
  company_category: "Tech",
  company_website_url: "https://Netflix.com/")

  puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "EBay",
  company_category: "E-Commerce",
  company_website_url: "https://bcgdv.com/")

  puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "Microsoft",
  company_category: "Tech",
  company_website_url: "https://Microsoft.com/")

  puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "OpenAI",
  company_category: "Tech",
  company_website_url: "https://openai.com/")

  puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "Tesla",
  company_category: "Automotive",
  company_website_url: "https://tesla.com/")

  puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "BCG Digital Ventures",
  company_category: "Tech",
  company_website_url: "https://bcgdv.com/")

  puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "Uber",
  company_category: "Transportation Mobility",
  company_website_url: "https://bcgdv.com/")

  puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "Samsung",
  company_category: "Tech",
  company_website_url: "https://samsung.com/")

  puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "Intel",
  company_category: "Tech",
  company_website_url: "https://intel.com/")

  puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "Shopify",
  company_category: "E-Commerce",
  company_website_url: "https://Shopify.com/")

  puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "Intel",
  company_category: "Tech",
  company_website_url: "https://intel.com/")

  puts "Created company - #{Company.last.company_name}"

Company.create(
  company_name: "Sony",
  company_category: "Electronics",
  company_website_url: "https://Sony.com/")

  puts "Created company - #{Company.last.company_name}"

  puts "creating more companies just in case :)"

Company.create(
  company_name: "Etsy",
  company_category: "E-Commerce",
  company_website_url: "https://Etsy.com/")

Company.create(
  company_name: "Reliance Health",
  company_category: "Healthcare",
  company_website_url: "https://reliancehealth.com/")

Company.create(
  company_name: "OXK",
  company_category: "Crypto",
  company_website_url: "https://okx.com/")

Company.create(
  company_name: "Cleo",
  company_category: "Finance",
  company_website_url: "https://cleo.com/")

Company.create(
  company_name: "Kubernetes",
  company_category: "Tech",
  company_website_url: "https://kubernetes.com/")

Company.create(
  company_name: "Forter",
  company_category: "Tech",
  company_website_url: "https://forter.com/")

Company.create(
  company_name: "Synthesia",
  company_category: "Tech",
  company_website_url: "https://synthesia.com/")

Company.create(
  company_name: "DRW",
  company_category: "Finance",
  company_website_url: "https://drw.com/")

Company.create(
  company_name: "Wise",
  company_category: "Finance",
  company_website_url: "https://wise.com/")

Company.create(
  company_name: "Elemental Excelerator",
  company_category: "Tech",
  company_website_url: "https://elementalexcelerator.com/")

Company.create(
  company_name: "Relativity Space",
  company_category: "Tech",
  company_website_url: "https://relativityspace.com/")

Company.create(
  company_name: "Zscaler",
  company_category: "Tech",
  company_website_url: "https://zscaler.com/")

Company.create(
  company_name: "Mozilla",
  company_category: "Tech",
  company_website_url: "https://mozilla.com/")

Company.create(
  company_name: "Alby",
  company_category: "Tech",
  company_website_url: "https://alby.com/")

Company.create(
  company_name: "Forage",
  company_category: "Tech",
  company_website_url: "https://forage.com/")

Company.create(
  company_name: "Tenstorrent",
  company_category: "Tech",
  company_website_url: "https://tenstorrent.com/")

Company.create(
  company_name: "Jane Street",
  company_category: "Finance",
  company_website_url: "https://janestreet.com/")

Company.create(
  company_name: "Brain Station",
  company_category: "Tech",
  company_website_url: "https://brainstation.com/")

Company.create(
  company_name: "GWI",
  company_category: "Tech",
  company_website_url: "https://gwi.com/")

Company.create(
  company_name: "Monzo",
  company_category: "Finance",
  company_website_url: "https://monzo.com/")

  Company.create(
      company_name: "Jobber",
      company_category: "Tech",
      company_website_url: "https://jobber.com/")

  Company.create(
    company_name: "Tele Health",
    company_category: "Healthcare",
    company_website_url: "https://telehealth.com/")

  Company.create(
    company_name: "Knowde",
    company_category: "Tech",
    company_website_url: "https://knowde.com/")

  Company.create(
    company_name: "Code Path",
    company_category: "Tech",
    company_website_url: "https://codepath.com/")

  Company.create(
    company_name: "Workato",
    company_category: "Tech",
    company_website_url: "https://workato.com/")

    Company.create(
      company_name: "Opendoor",
      company_category: "Tech",
      company_website_url: "https://opendoor.com/")

      Company.create(
        company_name: "Culture Amp",
        company_category: "Tech",
        company_website_url: "https://cultureamp.com/")


    Company.create(
      company_name: "Narvar",
        company_category: "Tech",
        company_website_url: "https://narvar.com/")


        Company.create(
          company_name: "Grammarly",
            company_category: "Tech",
            company_website_url: "https://grammarly.com/")


            Company.create(
              company_name: "Halcyon",
                company_category: "Tech",
                company_website_url: "https://halcyon.com/")

                Company.create(
                  company_name: "Motive",
                    company_category: "Tech",
                    company_website_url: "https://motive.com/")

                    Company.create(
                      company_name: "Synack",
                        company_category: "Tech",
                        company_website_url: "https://synack.com/")

                        Company.create(
                          company_name: "SoSafe GmbH",
                            company_category: "Tech",
                            company_website_url: "https://sosafe.com/")

                            Company.create(
                              company_name: "Gemini",
                                company_category: "Tech",
company_website_url: "https://gemini.com/")


puts "Created company - #{Company.last.company_name}"

puts "Created #{Company.count} companies"

puts "-------------------------------------"

puts "Creating new jobs..."

# Later: Add additional fields and change fields e.g. notice_period_weeks
# NB. Whenever changing a field, you need to adjust 3 places: Job Model, User Model and Default Value

# TODO: Update seed file to be in alphabetical order
# TODO: Add additional fields to each job model
# TODO: Write out ats_formats for each job and the job's requirements

# --------------------------------
# New Seed File Structure
# --------------------------------

# ["https://apply.workable.com/9fin/j/437E57E57C/", #
#  "https://apply.workable.com/builderai/j/DD834B7F18/",
#  "https://apply.workable.com/get-reliance-health/j/26CF020B41/",
#  "https://apply.workable.com/joinblink/j/C75195FF87/",
#  "https://apply.workable.com/kroo/j/C51C29B6C0",
#  "https://apply.workable.com/quantexa/j/BFDDA845A0",
#  "https://boards.eu.greenhouse.io/ably30/jobs/4183821101",
#  "https://boards.eu.greenhouse.io/synthesia/jobs/4250474101",
#  "https://boards.greenhouse.io/bcgdv/jobs/6879714002?gh_jid=6879714002",
#  # "https://boards.greenhouse.io/brainstation/jobs/5802728003",
#  "https://boards.greenhouse.io/cleoai/jobs/5033034002",
#  "https://boards.greenhouse.io/coreweave/jobs/4241710006",
#  "https://boards.greenhouse.io/deliveroo/jobs/5447359",
#  "https://boards.greenhouse.io/deliveroo/jobs/5094403",
#  "https://boards.greenhouse.io/drweng/jobs/5345753",
#  "https://boards.greenhouse.io/elementalexcelerator/jobs/5027131004",
#  "https://boards.greenhouse.io/forter/jobs/6889370002",
#  "https://boards.greenhouse.io/janestreet/jobs/4274809002",
#  "https://boards.greenhouse.io/joinforage/jobs/4155367007",
#  "https://boards.greenhouse.io/mozilla/jobs/5448569",
#  "https://boards.greenhouse.io/okx/jobs/5552949003",
#  "https://boards.greenhouse.io/relativity/jobs/6916371002",
#  "https://boards.greenhouse.io/tenstorrent/jobs/4120628007",
#  "https://boards.greenhouse.io/transferwise/jobs/5082330",
#  "https://boards.greenhouse.io/zscaler/jobs/4092460007",]

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

# application_details: {
#   description: {
#     locators: 'TODO'
#   },
#   other_keys: {
#     locators: 'TODO'
#   }
# },
# application_criteria: {
#   first_name: {
#     interaction: :input,
#     locators: 'TODO'
#   },
#   other_keys: {
#     locators: 'TODO'
#   },
# },

# -----------------
# Workable ATS
# -----------------

# 1. 9fin
Job.create!(
  job_title: "Software Engineer (Backend-Web Platforms)",
  job_description: "Technology has revolutionized equity markets with electronic trading, quant algos and instantaneous news. However, in debt capital markets, the picture is completely different. It still behaves like it's in the 1980s; trillions of dollars of trades are placed over the phone, news is slow, and corporate credit information is imperfect and scattered.",
  salary: 40000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_details: {
    description: {
      locators: 'TODO'
    },
    other_keys: {
      locators: 'TODO'
    }
  },
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'TODO'
    },
    other_keys: {
      locators: 'TODO'
    },
  },
  job_posting_url: "https://apply.workable.com/9fin/j/437E57E57C/",
  company_id: Company.find_by(company_name: '9fin').id,
  # applicant_tracking_system_id: ApplicantTrackingSystem.find_by(name: 'Workable').id,
  # ats_format_id: AtsFormat.find_by(name: 'Workable_1').id,
  captcha: false, # found in meta tag
  # Description, Responsibilities (Things You'll Work On), Backend Stack, Requirements, Benefits, Equal Opportunity Employer
)

puts "Created job - #{Job.last.job_title}"

# 2. Builder.ai
Job.create!(
  job_title: "Full Stack Software Engineer - React/Node",
  job_description: "We're on a mission to make app building so easy everyone can do it - regardless of their background, tech knowledge or budget. We've already helped thousands of entrepreneurs, small businesses and even global brands, like the BBC, Makro and Pepsi achieve their software goals and we've only just started.",
  salary: 42000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_details: {
    description: {
      locators: 'TODO'
    },
    other_keys: {
      locators: 'TODO'
    }
  },
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'TODO'
    },
    other_keys: {
      locators: 'TODO'
    },
  },
  job_posting_url: "https://apply.workable.com/builderai/j/DD834B7F18/",
  company_id: Company.find_by(company_name: 'Builder.ai').id,
  # applicant_tracking_system_id: ApplicantTrackingSystem.find_by(name: 'Workable').id,
  # ats_format_id: AtsFormat.find_by(name: 'Workable_1').id,
  captcha: false,
  # Description, Life at Company, About The Role, Requirements, Benefits
)

puts "Created job - #{Job.last.job_title}"

# 3. Gemini
Job.create!(
  job_title: "Cloud Network Engineer @ Gemini ",
  job_description: "Gemini is a crypto exchange and custodian that allows customers to buy, sell, store, and earn more than 30 cryptocurrencies like bitcoin, bitcoin cash, ether, litecoin, and Zcash. Gemini is a New York trust company that is subject to the capital reserve requirements, cybersecurity requirements, and banking compliance standards set forth by the New York State Department of Financial Services and the New York Banking Law. Gemini was founded in 2014 by twin brothers Cameron and Tyler Winklevoss to empower the individual through crypto.",
   salary: 98000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/embed/job_app?for=gemini&token=5203656",
  company_id: Company.find_by(company_name: 'Gemini').id,
  # applicant_tracking_system_id: ApplicantTrackingSystem.find_by(name: 'Workable').id,
  # ats_format_id: AtsFormat.find_by(name: 'Workable_1').id,
  captcha: false,
  # About Us, Position Overview, Responsibilities, Requirements, Benefits, Application Process
)

puts "Created job - #{Job.last.job_title}"

# 4. Blink
Job.create!(
  job_title: "Frontend Engineer",
  job_description: "Blink is the world's first workplace tool designed for frontline employees. Our award-winning platform transforms the working lives of society's most relied-on members.",
  salary: 40000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_details: {
    description: {
      locators: 'TODO'
    },
    other_keys: {
      locators: 'TODO'
    }
  },
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'TODO'
    },
    other_keys: {
      locators: 'TODO'
    },
  },
  job_posting_url: "https://apply.workable.com/joinblink/j/C75195FF87/",
  company_id: Company.find_by(company_name: 'Blink').id,
  # applicant_tracking_system_id: ApplicantTrackingSystem.find_by(name: 'Workable').id,
  # ats_format_id: AtsFormat.find_by(name: 'Workable_1').id,
  captcha: false,
  # Description, Responsibilities, Requirements, Benefits
)

puts "Created job - #{Job.last.job_title}"

# 5. Kroo
Job.create!(
  job_title: "Software Engineer-Full stack (Junior Level)",
  job_description: "Kroo has a big vision. To be the first bank that is both trusted and loved by its customers.We'’'re helping people take control of their financial future and achieve their goals, whilst making a positive impact on the planet. Here at Kroo, doing what is right is in our DNA. We act with integrity, transparency and honesty. We think big, dream big, and relentlessly pursue our goals. We like to be bold, break new ground, and we never stop learning. But most importantly, we are on this journey together.",
  salary: 30000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: 'CA_18698'
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: 'fieldset[data-ui="QA_6308627"]',
      option: "label",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: 'QA_6308628'
    },
    notice_period: {
      interaction: :input,
      locators: 'QA_6308629'
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: 'input#input_QA_6308630_input',
      option: "li"
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: 'QA_6308631',
    },
    employee_referral: {
      interaction: :input,
      locators: 'QA_6427777'
    }
  },
  job_posting_url: "https://apply.workable.com/kroo/j/C51C29B6C0",
  company_id: Company.find_by(company_name: 'Kroo').id,
  # applicant_tracking_system_id: ApplicantTrackingSystem.find_by(name: 'Workable').id,
  # ats_format_id: AtsFormat.find_by(name: 'Workable_1').id,
  captcha: false,
  # Description, How You'll Contribute, Technologies, Requirements, Process, Benefits, Hybrid Working, Diversity & Inclusion, Recruitment Agencies
)

# 6. Quantexa
Job.create!(
  job_title: "Front End Engineer",
  job_description: "At Quantexa we believe that people and organizations make better decisions when those decisions are put in context - we call this Contextual Decision Intelligence. Contextual Decision Intelligence is the new approach to data analysis that shows the relationships between people, places and organizations - all in one place - so you gain the context you need to make more accurate decisions, faster.",
  salary: 40000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_details: {
    description: {
      locators: 'TODO'
    },
    other_keys: {
      locators: 'TODO'
    }
  },
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'TODO'
    },
    other_keys: {
      locators: 'TODO'
    },
  },
  job_posting_url: "https://apply.workable.com/quantexa/j/BFDDA845A0",
  company_id: Company.find_by(company_name: 'Quantexa').id
  # applicant_tracking_system_id: ApplicantTrackingSystem.find_by(name: 'Workable').id,
  # ats_format_id: AtsFormat.find_by(name: 'Workable_1').id,
)

puts "Created job - #{Job.last.job_title}"

# -----------------
# Greenhouse ATS
# -----------------

# 7. Alby
Job.create!(
  job_title: "Web Engineer - Content @ Ably",
  job_description: "You will be responsible for helping shape the future of our content marketing and publishing platforms. You'll draw on your broad range of expertise across the web stack to design, develop and deliver.",
  salary: 48000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.eu.greenhouse.io/ably30/jobs/4183821101",
  company_id: Company.find_by(company_name: 'Alby').id
)

puts "Created job - #{Job.last.job_title}"

# 8. Synthesia
Job.create!(
  job_title: "Webflow Developer @ Synthesia ",
  job_description: "Support full-stack engineering teams, Communicate across functions and drive engineering initiatives,Empathise with and help define product strategy for our target audience.",
  salary: 41000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,

  # NB: THIS ALL CONVERTS TO STRING WHEN PARSED TO JSON IN THE DATABASE!

  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.eu.greenhouse.io/synthesia/jobs/4250474101",
  company_id: Company.find_by(company_name: 'Synthesia').id
)

puts "Created job - #{Job.last.job_title}"

# 9. BCG Digital Ventures
Job.create!(
  job_title: "Fullstack Engineer: Green-Tech Business",
  job_description: "Part of a new team, we are hiring software engineers to work in squads on developing applications for the company'’'s digital portfolio, built in the Azure ecosystem. You will play a key role in designing, developing, maintaining and improving business'’' key product, thus enabling customers to measure their climate impact.",
  salary: 40000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'first_name'
    },
    last_name: {
      interaction: :input,
      locators: 'last_name'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    city: {
      interaction: :input,
      locators: 'job_application[location]'
    },
    location_click: {
      interaction: :listbox,
      locators: 'ul#location_autocomplete-items-popup'
    },
    resume: {
      interaction: :upload,
      locators: 'button[aria-describedby="resume-allowable-file-types"'
    },
    linkedin_profile: {
      interaction: :input,
      locators: 'job_application_answers_attributes_0_text_value'
    },
    personal_website: {
      interaction: :input,
      locators: 'job_application_answers_attributes_1_text_value'
    },
    heard_from: {
      interaction: :input,
      locators: 'job_application_answers_attributes_2_text_value'
    },
    right_to_work: {
      interaction: :select,
      locators: 'select#job_application_answers_attributes_3_boolean_value',
      option: 'option'
    },
    require_visa?: {
      interaction: :select,
      locators: 'select#job_application_answers_attributes_4_boolean_value',
      option: 'option'
    }
  },
  job_posting_url: "https://boards.greenhouse.io/bcgdv/jobs/6879714002?gh_jid=6879714002",
  company_id: Company.find_by(company_name: 'BCG Digital Ventures').id
)

puts "Created job - #{Job.last.job_title}"

# 10. BrainStation (No longer open)
# Job.create!(
#   job_title: "Educator, Web Developer",
#   job_description: "BrainStation is a global leader in digital skills training and development, offering a 12-week bootcamp program in Web Development. BrainStation is currently hiring a Senior Web Developer to teach our program through online and in-person teaching. BrainStation Educators are given the unique opportunity to teach, research, and further develop their skills, while teaching in a dynamic, project-based setting.",
#   salary: 40000,
#   date_created: date_created.sample,
#   application_deadline: deadlines.sample,
#   job_posting_url: "https://boards.greenhouse.io/brainstation/jobs/5802728003",
#   company_id: Company.find_by(company_name: 'BrainStation').id
# )

# puts "Created job - #{Job.last.job_title}"

# 11. Cleo
Job.create!(
  job_title: "Backend Ruby Engineer",
  job_description: "Most people come to Cleo to do work that matters. Every day, we empower people to build a life beyond their next paycheck, building a beloved AI that enables you to forge your own path toward financial well-being.",
  salary: 40000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  job_posting_url: "https://boards.greenhouse.io/cleoai/jobs/5033034002",
  company_id: Company.find_by(company_name: 'Cleo').id
)

puts "Created job - #{Job.last.job_title}"

# 12. Coreweave

Job.create!(
  job_title: "Senior Engineer @ Kubernetes Core Interfacesat CoreWeave ",
  job_description: "We are looking for a Senior Engineer - Java (Defi - DEX) to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application. ",
  salary: 38000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,

  # NB: THIS ALL CONVERTS TO STRING WHEN PARSED TO JSON IN THE DATABASE!

  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/coreweave/jobs/4241710006",
  company_id: Company.find_by(company_name: 'Kubernetes').id
)

puts "Created job - #{Job.last.job_title}"

# 13. Deliveroo

Job.create!(
  job_title: "Software Engineer II - Full-Stack",
  job_description: "We're building the definitive online food company, transforming the way the world eats by making hyper-local food more convenient and accessible. We obsess about building the future of food, whilst using our network as a force for good. We're at the forefront of an industry, powered by our market-leading technology and unrivalled network to bring incredible convenience and selection to our customers.",
  salary: 31000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'first_name'
    },
    last_name: {
      interaction: :input,
      locators: 'last_name'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    city: {
      interaction: :input,
      locators: 'job_application[location]'
    },
    location_click: {
      interaction: :listbox,
      locators: 'ul#location_autocomplete-items-popup'
    },
    resume: {
      interaction: :upload,
      locators: 'button[aria-describedby="resume-allowable-file-types"'
    },
    linkedin_profile: {
      interaction: :input,
      locators: 'job_application_answers_attributes_0_text_value'
    },
    require_visa?: {
      interaction: :select,
      locators: 'select#job_application_answers_attributes_1_boolean_value',
      option: 'option'
    },
    heard_of_company?: {
      interaction: :select,
      locators: 'select#job_application_answers_attributes_2_boolean_value',
      option: 'option'
    }
  },
  job_posting_url: "https://boards.greenhouse.io/deliveroo/jobs/5447359",
  company_id: Company.find_by(company_name: 'Deliveroo').id
)

puts "Created job - #{Job.last.job_title}"

# 14. Deliveroo
Job.create!(
  job_title: "Software Engineer - Golang",
  job_description: "We're building the definitive online food company, transforming the way the world eats by making hyper-local food more convenient and accessible. We obsess about building the future of food, whilst using our network as a force for good. We're at the forefront of an industry, powered by our market-leading technology and unrivaled network to bring incredible convenience and selection to our customers.",
  salary: 40000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  job_posting_url: "https://boards.greenhouse.io/deliveroo/jobs/5094403",
  company_id: Company.find_by(company_name: 'Deliveroo').id
)

puts "Created job - #{Job.last.job_title}"

# 15. DRW
Job.create!(
  job_title: "Software Engineer - Commodities @ DRW   ",
  job_description: "DRW are looking for a Software Engineer to join the Commodities trading group to build and support data pipelines for the ingestion, management, and analysis of datasets used by analysts and traders.",
  salary: 60000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,

  # NB: THIS ALL CONVERTS TO STRING WHEN PARSED TO JSON IN THE DATABASE!

  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/drweng/jobs/5345753",
  company_id: Company.find_by(company_name: 'DRW').id
)

puts "Created job - #{Job.last.job_title}"

# 16. Elemental Excelerator
Job.create!(
  job_title: "Developer in Residence @ Elemental Excelerator ",
  job_description: "We are looking for a Developer in Residence to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application. ",
  salary: 29000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,

  # NB: THIS ALL CONVERTS TO STRING WHEN PARSED TO JSON IN THE DATABASE!

  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/elementalexcelerator/jobs/5027131004",
  company_id: Company.find_by(company_name: 'Elemental Excelerator').id
)

puts "Created job - #{Job.last.job_title}"

# 17. Forter
Job.create!(
  job_title: "Backend Payment Architech @ Forter",
  job_description: "Payment System Analysis: Conduct payment solution technical requirement deep dives with clients to understand their business goals",
  salary: 43000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/forter/jobs/6889370002",
  company_id: Company.find_by(company_name: 'Forter').id
)

puts "Created job - #{Job.last.job_title}"

# 18. Jane Street
Job.create!(
  job_title: "FPGA Engineer @ Jane Street",
  job_description: "We are looking for a FPGA Engineer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application. ",
  salary: 43000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,

  # NB: THIS ALL CONVERTS TO STRING WHEN PARSED TO JSON IN THE DATABASE!

  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/janestreet/jobs/4274809002",
  company_id: Company.find_by(company_name: 'Jane Street').id
)

puts "Created job - #{Job.last.job_title}"

# 19. Forage
Job.create!(
  job_title: "Principal Backend Engineer @ Forage",
  job_description: "We are looking for a Principal Backend Engineer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application. ",
  salary: 55000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,

  # NB: THIS ALL CONVERTS TO STRING WHEN PARSED TO JSON IN THE DATABASE!

  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },


  job_posting_url: "https://boards.greenhouse.io/joinforage/jobs/4155367007",
  company_id: Company.find_by(company_name: 'Forage').id
)

puts "Created job - #{Job.last.job_title}"

# 20. Mozilla
Job.create!(
  job_title: "Staff Full Stack Software Engineer @ Mozilla",
  job_description: "We are looking for a Staff Full Stack Software Engineer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application. ",
  salary: 81000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,

  # NB: THIS ALL CONVERTS TO STRING WHEN PARSED TO JSON IN THE DATABASE!

  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/mozilla/jobs/5448569",
  company_id: Company.find_by(company_name: 'Mozilla').id
)

puts "Created job - #{Job.last.job_title}"

# 21. OKX
Job.create!(
  job_title: "Senior Engineer - Java (Defi - DEX) @ OKX ",
  job_description: "We are looking for a Senior Engineer - Java (Defi - DEX) to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application. ",
  salary: 34000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,

  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/okx/jobs/5552949003",
  company_id: Company.find_by(company_name: 'OXK').id
)

puts "Created job - #{Job.last.job_title}"

# 22. Relativity
Job.create!(
  job_title: "Manager, Tooling Engineering @ Relativity Space",
  job_description: "We are looking for a Manager, Tooling Engineering to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application. ",
  salary: 60000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,

  # NB: THIS ALL CONVERTS TO STRING WHEN PARSED TO JSON IN THE DATABASE!

  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/relativity/jobs/6916371002",
  company_id: Company.find_by(company_name: 'Relativity Space').id
)

puts "Created job - #{Job.last.job_title}"

# 23. Tenstorrent
Job.create!(
  job_title: "Staff Emulation Methodology and Infrastructure Engineer @ Tenstorrent",
  job_description: "We are looking for a UI Developer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 35000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/tenstorrent/jobs/4120628007",
  company_id: Company.find_by(company_name: 'Tenstorrent').id
)

puts "Created job - #{Job.last.job_title}"

# 24. Wise
Job.create!(
  job_title: "Senior Backend Engineer - Fraud @ Wise",
  job_description: "We'’'re looking for a Senior Backend Engineer to join our Fraud team in London. You'’'ll be working on building and improving our fraud detection systems, which are used to protect our customers and Wise from fraudsters. You'’'ll be working in a cross-functional team with other engineers, product managers, data scientists and analysts to build and improve our fraud detection systems.",
  salary: 55000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/transferwise/jobs/5082330",
  company_id: Company.find_by(company_name: 'Wise').id
)

puts "Created job - #{Job.last.job_title}"

# 25. Zscaler
Job.create!(
  job_title: "Senior Infrastructure Deployment Engineer @ Zscaler ",
  job_description: "We are looking for a Senior Infrastructure Deployment Engineer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application. ",
  salary: 45000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/zscaler/jobs/4092460007",
  company_id: Company.find_by(company_name: 'Zscaler').id
)
puts "Created job - #{Job.last.job_title}"
# 26. GWI
Job.create!(
  job_title: "Data Science Talent Pool @ GWI ",
  job_description: "Our Data Science department is split between the Data Analytics Engineering and Data Science teams consisting of Data Scientists and Machine Learning Engineers reporting to the Team Leads under the VP of Data Science or the Director of Data Analytics Engineering. The teams mainly work with GCP, Python and SQL. ",
  salary: 66000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/globalwebindex/jobs/6940363002",
  company_id: Company.find_by(company_name: 'GWI').id
)
puts "Created job - #{Job.last.job_title}"

# 27. Monzo
Job.create!(
  job_title: "Director of Data Science, Financial Crime @ Monzo ",
  job_description: "We are looking for a Director of Data Science, Financial Crime to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application ",
  salary: 120000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/monzo/jobs/5463167",
  company_id: Company.find_by(company_name: 'Monzo').id
)
puts "Created job - #{Job.last.job_title}"

# 28. Monzo
Job.create!(
  job_title: "Data science manager @ Monzo ",
  job_description: "We are looking for a Data science manager to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application ",
  salary: 100000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/monzo/jobs/5482027",
  company_id: Company.find_by(company_name: 'Monzo').id
)
puts "Created job - #{Job.last.job_title}"

# 29. Jobber
Job.create!(
  job_title: "Senior Data Science Manager @ Jobber ",
  job_description: "We are looking for a Senior Data Science Manager to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application ",
  salary: 90000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/jobber/jobs/7023846002",
  company_id: Company.find_by(company_name: 'Jobber').id
)
puts "Created job - #{Job.last.job_title}"

# 30. tele health
Job.create!(
  job_title: "Software Engineer @ Tele Health ",
  job_description: "We are looking for a Software Engineer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application ",
  salary: 90000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/doctolib/jobs/5811790003",
  company_id: Company.find_by(company_name: 'Tele Health').id
)
puts "Created job - #{Job.last.job_title}"

# 31. Knowde
Job.create!(
  job_title: "Back-End Software Engineer - Ruby/Rails @ Knowde ",
  job_description: "We are looking for a Back-End Software Engineer - Ruby/Rails to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application ",
  salary: 92000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/knowde/jobs/4378100003",
  company_id: Company.find_by(company_name: 'Knowde').id
)
puts "Created job - #{Job.last.job_title}"

# 32. Knowde
Job.create!(
  job_title: "Engineering Manager @ Knowde ",
  job_description: "We are looking for a Engineering Manager to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application ",
  salary: 88000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/knowde/jobs/5808402003",
  company_id: Company.find_by(company_name: 'Knowde').id
)
puts "Created job - #{Job.last.job_title}"

# 33. Knowde
Job.create!(
  job_title: "Front-End Software Engineer @ Knowde ",
  job_description: "We are looking for a Front-End Software Engineer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application ",
  salary: 99000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/knowde/jobs/4576119003",
  company_id: Company.find_by(company_name: 'Knowde').id
)
puts "Created job - #{Job.last.job_title}"

# 34. Knowde
Job.create!(
  job_title: "Senior Back-End Software Engineer @ Knowde ",
  job_description: "We are looking for a Senior Back-End Software Engineer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 93000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/knowde/jobs/4129896003",
  company_id: Company.find_by(company_name: 'Knowde').id
)
puts "Created job - #{Job.last.job_title}"

# 35. Code path
Job.create!(
  job_title: "Senior Ruby Engineer @ Codepath ",
  job_description: "We are looking for a Senior Back-End Software Engineer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 89000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/codepath/jobs/4035988007",
  company_id: Company.find_by(company_name: 'Code Path').id
)
puts "Created job - #{Job.last.job_title}"

# 36. Code path
Job.create!(
  job_title: "Lead Web Development Instructor @ Codepath ",
  job_description: "We are looking for a Lead Web Development Instructor to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 97000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/codepath/jobs/4059099007",
  company_id: Company.find_by(company_name: 'Code Path').id
)
puts "Created job - #{Job.last.job_title}"

# 37. Code path
Job.create!(
  job_title: "Cloud Infrastructure Engineer @ Codepath",
  job_description: "We are looking for a Cloud Infrastructure Engineer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 97000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/codepath/jobs/4141438007",
  company_id: Company.find_by(company_name: 'Code Path').id
)
puts "Created job - #{Job.last.job_title}"

# 38. workato
Job.create!(
  job_title: "Senior Ruby Engineer @ Workato",
  job_description: "We are looking for a Senior Ruby Engineer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 97000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/workato/jobs/7016061002",
  company_id: Company.find_by(company_name: 'Workato').id
)
puts "Created job - #{Job.last.job_title}"

# 39. Open door
Job.create!(
  job_title: "Staff Software Engineer - Ruby on rails OR Golang @ Opendoor",
  job_description: "We are looking for a Staff Software Engineer - Ruby on rails OR Golang to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 91000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/opendoor/jobs/4255190006",
  company_id: Company.find_by(company_name: 'Opendoor').id
)
puts "Created job - #{Job.last.job_title}"

# 40. Culture Amp
Job.create!(
  job_title: "Senior Engineer - Ruby @ Culture Amp",
  job_description: "We are looking for a Senior Engineer - Ruby to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 89000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/cultureamp/jobs/5538191",
  company_id: Company.find_by(company_name: 'Culture Amp').id
)
puts "Created job - #{Job.last.job_title}"
# 41. Culture Amp
Job.create!(
  job_title: "Automation Engineer @ Culture Amp",
  job_description: "We are looking for a Automation Engineer to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 97000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/cultureamp/jobs/5496553",
  company_id: Company.find_by(company_name: 'Culture Amp').id
)
puts "Created job - #{Job.last.job_title}"
# 42. Narvar
Job.create!(
  job_title: "Staff Engineer, Ruby on Rails and React @ Narvar",
  job_description: "We are looking for a Staff Engineer, Ruby on Rails and React to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 89000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/narvar/jobs/5388111",
  company_id: Company.find_by(company_name: 'Narvar').id
)
puts "Created job - #{Job.last.job_title}"
# 43.Narvar
Job.create!(
  job_title: "Director of Machine Learning @ Narvar",
  job_description: "We are looking for a Director of Machine Learning to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 120000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/narvar/jobs/5436866",
  company_id: Company.find_by(company_name: 'Narvar').id
)
puts "Created job - #{Job.last.job_title}"
# 44. Synack
Job.create!(
  job_title: "Senior Backend Engineer - Ruby on Rails @ Synack",
  job_description: "We are looking for a Senior Backend Engineer - Ruby on Rails to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 110000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/synack/jobs/5469197",
  company_id: Company.find_by(company_name: 'Synack').id
)
puts "Created job - #{Job.last.job_title}"
# 45. grammarly
Job.create!(
  job_title: " Software Engineer, Back-End (Cloud Product Platform) -  @ Grammarly",
  job_description: "We are looking for a Software Engineer, Back-End (Cloud Product Platform) -  to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 110000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/grammarly/jobs/5349293",
  company_id: Company.find_by(company_name: 'Grammarly').id
)
puts "Created job - #{Job.last.job_title}"
# 46. grammarly
Job.create!(
  job_title: " AI Security Researcher -  @ Grammarly",
  job_description: "We are looking for a AI Security Researcher -  to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 120000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/grammarly/jobs/5523286",
  company_id: Company.find_by(company_name: 'Grammarly').id
)
puts "Created job - #{Job.last.job_title}"
# 47. Halcyon
Job.create!(
  job_title: " Cloud Backend Engineer -  @ Halcyon",
  job_description: "We are looking for a Cloud Backend Engineer -  to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 112000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/halcyon/jobs/4891571004",
  company_id: Company.find_by(company_name: 'Halcyon').id
)
puts "Created job - #{Job.last.job_title}"
# 48. Halcyon
Job.create!(
  job_title: " Windows Kernel Engineer -  @ Halcyon",
  job_description: "We are looking for a Windows Kernel Engineer -  to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 87000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/halcyon/jobs/4891571004",
  company_id: Company.find_by(company_name: 'Halcyon').id
)
puts "Created job - #{Job.last.job_title}"
# 49. Motive
Job.create!(
  job_title: " Cloud Infrastructure Engineer -  @ Motive",
  job_description: "We are looking for a Cloud Infrastructure Engineer -  to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 102000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
  job_posting_url: "https://boards.greenhouse.io/gomotive/jobs/7030195002",
  company_id: Company.find_by(company_name: 'Motive').id
)
puts "Created job - #{Job.last.job_title}"
# 50. Motive
Job.create!(
  job_title: " Data Engineer -  @ Motive",
  job_description: "We are looking for a Data Engineer -  to join our team and help us build the future of work. You will be working closely with our product and design teams to build and improve our web application",
  salary: 101000,
  date_created: date_created.sample,
  application_deadline: deadlines.sample,
  application_criteria: {
    first_name: {
      interaction: :input,
      locators: 'firstname'
    },
    last_name: {
      interaction: :input,
      locators: 'lastname'
    },
    email: {
      interaction: :input,
      locators: 'email'
    },
    phone_number: {
      interaction: :input,
      locators: 'phone'
    },
    resume: {
      interaction: :upload,
      locators: 'input[type="file"]'
    },
    salary_expectation_text: {
      interaction: :input,
      locators: ''
    },
    right_to_work: {
      interaction: :radiogroup,
      locators: '',
      option: "",
    },
    salary_expectation_figure: {
      interaction: :input,
      locators: ''
    },
    notice_period: {
      interaction: :input,
      locators: ''
    },
    preferred_pronoun_select: {
      interaction: :combobox,
      locators: '',
      option: ""
    },
    preferred_pronoun_text: {
      interaction: :input,
      locators: '',
    },
    employee_referral: {
      interaction: :input,
      locators: ''
    }
  },
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

# -----------------------
# Template Job Structure:

# Job.create!(
#   job_title: "XXX",
#   job_description: "XXX",
#   salary: XXX,
#   date_created: Date.XXX,
#   application_criteria: {
#     first_name: {
#       interaction: :input,
#       locators: XXX
#     },
#     last_name: {
#       interaction: :input,
#       locators: XXX
#     },
#     email: {
#       interaction: :input,
#       locators: XXX
#     },
#     phone_number: {
#       interaction: :input,
#       locators: XXX
#     },
#     resume: {
#       interaction: :upload,
#       locators: XXX
#     },
#     salary_expectation_text: {
#       interaction: :input,
#       locators: XXX
#     },
#     right_to_work: {
#       interaction: :input,
#       locators: XXX
#     },
#     salary_expectation_figure: {
#       interaction: :input,
#       locators: XXX
#     },
#     notice_period: {
#       interaction: :input,
#       locators: XXX
#     },
#     preferred_pronoun_select: {
#       interaction: :input,
#       locators: XXX
#     },
#     preferred_pronoun_text: {
#       interaction: :input,
#       locators: XXX
#     },
#     employee_referral: {
#       interaction: :input,
#       locators: XXX
#     }
#   },
#   application_deadline: Date.XXX,
#   job_posting_url: "XXX",
#   company_id: Company.XXX.id)

# ---------------------------
# Test method:
# ApplyJob.perform_now(16, 7)
