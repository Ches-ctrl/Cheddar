# TODO: Add fields to company and job models
# TODO: Source data on each field for each company and job (use Upwork)


puts "Creating new Consulting ATS systems, companies and jobs..."

puts "-------------------------------------"

puts "Creating new ATS formats..."

# ApplicantTrackingSystem.create(
#   name: "Workable",
#   website_url: "https://workable.com/",
# )

# puts "Created ATS - #{ApplicantTrackingSystem.last.name}"

puts "-------------------------------------"

puts "Creating new companies..."

Company.find_or_create_by(
  company_name: "McKinsey & Company",
  company_website_url: "https://www.mckinsey.com/",
  location: "London, UK",
  industry: "Management Consulting",
)

puts "Created company - #{Company.last.company_name}"

Company.find_or_create_by(
  company_name: "",
  company_category: "",
  company_website_url: ""
)

puts "Created company - #{Company.last.company_name}"

Company.find_or_create_by(
  company_name: "",
  company_category: "",
  company_website_url: ""
)

puts "Created company - #{Company.last.company_name}"

Company.find_or_create_by(
  company_name: "",
  company_category: "",
  company_website_url: ""
)

puts "Created company - #{Company.last.company_name}"

puts "Created #{Company.count} companies"

puts "-------------------------------------"

puts "Creating new jobs..."

# -----------------

# 1. McKinsey & Company
Job.create!(
  job_title: "",
  job_description: "",
  salary: 0,
  date_created: "14/06/2021",
  application_deadline: "14/06/2021",
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
  job_posting_url: "",
  company_id: "",
  # applicant_tracking_system_id: ApplicantTrackingSystem.find_by(name: 'Workable').id,
  # ats_format_id: AtsFormat.find_by(name: 'Workable_1').id,
  captcha: false, # found in meta tag
  # Description, Responsibilities (Things You'll Work On), Backend Stack, Requirements, Benefits, Equal Opportunity Employer
)

puts "Created job - #{Job.last.job_title}"
