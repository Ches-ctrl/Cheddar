module Ats::Greenhouse
  extend ActiveSupport::Concern

  # TODO: Update greenhouse fields to be just the core set, with the additional set to be scraped each time
  # TODO: Handle multiple greenhouse URL formats

  # ---------------
  # Company Details
  # ---------------
  def self.get_company_details(url)
    p "Getting greenhouse company details - #{url}"
    ats_system = ApplicantTrackingSystem.find_by(name: 'Greenhouse')

    match = parse_url(url)
    return unless match
    ats_identifier = match[1]

    company_name, description = fetch_company_data(ats_identifier)

    company = Company.find_by(company_name: company_name)
    new_company = false

    if company.nil?
      company = Company.create(
        company_name: company_name,
        ats_identifier: ats_identifier,
        applicant_tracking_system_id: ats_system.id,
        url_ats_api: "#{ats_system.base_url_api}#{ats_identifier}",
        url_ats_main: "#{ats_system.base_url_main}#{ats_identifier}"
      )
      new_company = true
      update_description_and_ats(company, description, ats_identifier)
      update_company_url_and_website(company, url)
    end

    # p "Calling GetAllJobUrls"
    # GetAllJobUrls.new(company).get_all_job_urls if new_company
    # p "Finished GetAllJobUrls"

    puts "Created / Updated company - #{company.company_name}"
    company
  end

  def self.parse_url(url)
    # Ability to handle multiple URLs via regex - not tested
    # TODO: Resolve the potential regex match structures and test them (non priority)
    # regex_formats = [
    #   %r{https://boards\.greenhouse\.io/([^/]+)/jobs},
    #   %r{https://boards\.greenhouse\.io/([^/]+)/jobs/\d+},
    #   %r{https://boards\.greenhouse\.io/embed/job_app\?for=([^&]+)},
    #   %r{https://boards\.[^.]+\.greenhouse\.io/embed/job_app\?for=([^&]+)},
    #   %r{https://boards-api\.greenhouse\.io/v1/boards/([^/]+)},
    #   %r{https://boards-api\.greenhouse\.io/v1/boards/([^/]+)/jobs},
    #   %r{https://boards-api\.greenhouse\.io/v1/boards/([^/]+)/jobs/\d+},
    #   %r{https://boards-api\.greenhouse\.io/([^/]+)},
    #   %r{https://boards-api\.greenhouse\.io/([^/]+)/jobs},
    #   %r{https://boards-api\.greenhouse\.io/([^/]+)/jobs/\d+}
    # ]

    # regex_formats.each do |regex|
    #   match = url.match(regex)
    #   if match
    #     company_name = match[1]
    #     puts "Company Name: #{company_name}"
    #     break
    #   end
    # end

    url.match(%r{https://boards\.greenhouse\.io/([^/]+)/jobs/\d+})
  end

  def self.fetch_company_data(ats_identifier)
    # Could request the base_url_api from the database but probably more efficient to hardcode here given requirement to split by ATS?
    company_api_url = "https://boards-api.greenhouse.io/v1/boards/#{ats_identifier}"
    uri = URI(company_api_url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    [data['name'], data['content']]
  end

  def self.update_description_and_ats(company, description, ats_identifier)
    company.update(description: description) if company.description.blank?
    company.update(applicant_tracking_system_id: ApplicantTrackingSystem.find_by(name: 'Greenhouse').id) if company.applicant_tracking_system_id.blank?
    company.update(ats_identifier: ats_identifier) if company.ats_identifier.blank?
  end

  def self.update_company_url_and_website(company, url)
    cleaned_url = url.gsub(/\/jobs\/.*/, '')
    original_url = URI.parse(cleaned_url)
    p original_url

    http = Net::HTTP.new(original_url.host, original_url.port)
    http.use_ssl = true if original_url.scheme == 'https'

    request = Net::HTTP::Get.new(original_url.request_uri)
    response = http.request(request)

    if response.is_a?(Net::HTTPRedirection)
      redirected_url = URI.parse(response['Location'])
      company_website_url = redirected_url.host
      company.update(url_careers: redirected_url)
      company.update(company_website_url: company_website_url)
    else
      p "No redirect for #{company_website_url}"
    end
  end

  # ---------------
  # Job Details
  # ---------------
  def self.get_job_details(job)
    p "Getting greenhouse job details: #{job}"
  end

  # ---------------
  # GetFormFieldsJob
  # ---------------

  # TODO: Add Greenhouse code here

  # ---------------
  # Application Fields
  # ---------------

  # Add labels?
  # Add placeholders?

  # TODO: Add Job Application Question to DB Schema
  # TODO: Clarify which characteristics of a question are required in order to properly allow user input

  # Options:
  # Just scrape required fields
  # Scrape all fields, minimal characteristics
  # Scrape all fields, all characteristics

  GREENHOUSE_CORE_FIELDS = {
    first_name: {
      interaction: :input,
      locators: 'first_name',
      required: true,
    },
    last_name: {
      interaction: :input,
      locators: 'last_name',
      required: true,
    },
    email: {
      interaction: :input,
      locators: 'email',
      required: true,
    },
    phone_number: {
      interaction: :input,
      locators: 'phone',
      required: true,
    },
    city: {
      interaction: :input,
      locators: 'job_application[location]',
      required: true,
    },
    location_click: {
      interaction: :listbox,
      locators: 'ul#location_autocomplete-items-popup'
    },
    resume: {
      interaction: :upload,
      locators: 'button[aria-describedby="resume-allowable-file-types"',
      required: true,
    },
    # cover_letter: {
    #   interaction: :upload,
    #   locators: 'button[aria-describedby="cover_letter-allowable-file-types"]',
    #   required: false
    # }
  }

  GREENHOUSE_ADDITIONAL_FIELDS = {
    school: {
      interaction: :select,
      locators: 's2id_education_school_name_0',
      required: true,
      placeholder: 'Select a School',
      data_url: 'https://boards-api.greenhouse.io/v1/boards/phonepe/education/schools',
    },
    degree: {
      interaction: :select,
      locators: 's2id_education_degree_0',
      required: false,
    },
    discipline: {
      interaction: :select,
      locators: 's2id_education_discipline_0',
      required: false,
    },
    ed_start_date_year: {
      interaction: :input,
      locators: 'job_application[educations][][start_date][year]',
      required: true,
    },
    ed_end_date_year: {
      interaction: :input,
      locators: 'job_application[educations][][end_date][year]',
      required: true,
    },
    company_name: {
      interaction: :input,
      locators: 'job_application[employments][][company_name]',
      required: true,
    },
    title: {
      interaction: :input,
      locators: 'job_application[employments][][title]',
      required: true,
    },
    emp_start_date_month: {
      interaction: :input,
      locators: 'job_application[employments][][start_date][month]',
      required: true,
    },
    emp_start_date_year: {
      interaction: :input,
      locators: 'job_application[employments][][start_date][year]',
      required: true,
    },
    emp_end_date_month: {
      interaction: :input,
      locators: 'job_application[employments][][end_date][month]',
      required: true,
    },
    emp_end_date_year: {
      interaction: :input,
      locators: 'job_application[employments][][end_date][year]',
      required: true,
    },
    linkedin_profile: {
      interaction: :input,
      locators: 'input[autocomplete="custom-question-linkedin-profile"]',
      required: false,
    },
    personal_website: {
      interaction: :input,
      locators: 'input[autocomplete="custom-question-website"], input[autocomplete="custom-question-portfolio-linkwebsite"]',
      required: false,
    },
    gender: {
      interaction: :input,
      locators: 'input[autocomplete="custom-question-website"], input[autocomplete="custom-question-portfolio-linkwebsite"]',
      required: false,
    },
    # location_click: {
    #   interaction: :listbox,
    #   locators: 'ul#location_autocomplete-items-popup'
    # },

    # heard_from: {
    #   interaction: :input,
    #   locators: 'input[autocomplete="custom-question-how-did-you-hear-about-this-job"]'
    # },
    # require_visa?: {
    #   interaction: :input,
    #   locators: 'textarea[autocomplete="custom-question-would-you-need-sponsorship-to-work-in-the-uk-"]'
    # },
  }

  GREENHOUSE_DEGREE_OPTIONS = [
    "High School",
    "Associate's Degree",
    "Bachelor's Degree",
    "Master's Degree",
    "Master of Business Administration (M.B.A.)",
    "Juris Doctor (J.D.)",
    "Doctor of Medicine (M.D.)",
    "Doctor of Philosophy (Ph.D.)",
    "Engineer's Degree",
    "Other",
  ]

  GREENHOUSE_DISCIPLINE_OPTIONS = [
    "Accounting",
    "African Studies",
    "Agriculture",
    "Anthropology",
    "Applied Health Services",
    "Architecture",
    "Art",
    "Asian Studies",
    "Biology",
    "Business",
    "Business Administration",
    "Chemistry",
    "Classical Languages",
    "Communications &amp; Film",
    "Computer Science",
    "Dentistry",
    "Developing Nations",
    "Discipline Unknown",
    "Earth Sciences",
    "Economics",
    "Education",
    "Electronics",
    "Engineering",
    "English Studies",
    "Environmental Studies",
    "European Studies",
    "Fashion",
    "Finance",
    "Fine Arts",
    "General Studies",
    "Health Services",
    "History",
    "Human Resources Management",
    "Humanities",
    "Industrial Arts &amp; Carpentry",
    "Information Systems",
    "International Relations",
    "Journalism",
    "Languages",
    "Latin American Studies",
    "Law",
    "Linguistics",
    "Manufacturing &amp; Mechanics",
    "Mathematics",
    "Medicine",
    "Middle Eastern Studies",
    "Naval Science",
    "North American Studies",
    "Nuclear Technics",
    "Operations Research &amp; Strategy",
    "Organizational Theory",
    "Philosophy",
    "Physical Education",
    "Physical Sciences",
    "Physics",
    "Political Science",
    "Psychology",
    "Public Policy",
    "Public Service",
    "Religious Studies",
    "Russian &amp; Soviet Studies",
    "Scandinavian Studies",
    "Science",
    "Slavic Studies",
    "Social Science",
    "Social Sciences",
    "Sociology",
    "Speech",
    "Statistics &amp; Decision Theory",
    "Urban Studies",
    "Veterinary Medicine",
    "Other",
  ]
end

#  Issue with standard form fields - 2x being cross-added
#  Reconcile standard set of form fields
#  Then add additional fields
#  Move service to be a background job after job.create
