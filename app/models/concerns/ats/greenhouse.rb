module Ats::Greenhouse
  # TODO: Update greenhouse fields to be just the core set, with the additional set to be scraped each time
  extend ActiveSupport::Concern

  # Greenhouse Main URLs:
  # https://boards.greenhouse.io/#{company_name}/jobs/#{job_id}
  # https://boards.greenhouse.io/embed/job_app?for=#{company_name}&token=#{job_id}
  # https://boards.#{region_code}.greenhouse.io/embed/job_app?for=#{company_name}&token=#{job_id}

  # Greenhouse API URLs:
  # https://boards-api.greenhouse.io/v1/boards/#{company_name} # Sometimes redirects
  # https://boards-api.greenhouse.io/#{company_name}
  # https://boards-api.greenhouse.io/#{company_name}/jobs
  # https://boards-api.greenhouse.io/#{company_name}/jobs/#{job_id}

  # TODO: Handle multiple greenhouse URL formats
  # Not yet tested but included for reference
  # def convert_greenhouse_url(url)
  #   # Define regular expressions to match the URL formats
  #   url_pattern_1 = %r{https://boards\.greenhouse\.io/([^/]+)/jobs/(\d+)}
  #   url_pattern_2 = %r{https://boards\.greenhouse\.io/embed/job_app\?for=([^&]+)&token=(\w+)}
  #   url_pattern_3 = %r{https://boards\.([^\.]+)\.greenhouse\.io/embed/job_app\?for=([^&]+)&token=(\w+)}

  #   if (match = url.match(url_pattern_1))
  #     # Extract company_name and job_id from the first URL format
  #     company_name, job_id = match.captures
  #   elsif (match = url.match(url_pattern_2))
  #     # Extract company_name and job_id from the second URL format
  #     company_name, job_id = match.captures
  #   elsif (match = url.match(url_pattern_3))
  #     # Extract region_code, company_name, and job_id from the third URL format
  #     region_code, company_name, job_id = match.captures
  #   else
  #     # Handle invalid URL format or no match
  #     return nil
  #   end

  #   # Construct the desired URL format
  #   converted_url = "https://boards.greenhouse.io/#{company_name}/jobs/#{job_id}"

  #   # Return the converted URL
  #   converted_url
  # end

  # Types of hosting a Jobs Board with Greenhouse:
  # - Host a job board with Greenhouse
  # - Embed a Greenhouse job board in your website
  # - Embed an API-driven job board in your website and host job applications with Greenhouse
  # - Embed an API-driven job board and application form in your website
  # - Create a fully API-driven job board

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
    resume: {
      interaction: :upload,
      locators: 'button[aria-describedby="resume-allowable-file-types"',
      required: true,
    },
    cover_letter: {
      interaction: :upload,
      locators: 'button[aria-describedby="cover_letter-allowable-file-types"]',
      required: false,
    },
  }

  # Add labels?
  # Add placeholders?

  # TODO: Add Job Application Question to DB Schema
  # TODO: Clarify which characteristics of a question are required in order to properly allow user input

  # Options:
  # Just scrape required fields
  # Scrape all fields, minimal characteristics
  # Scrape all fields, all characteristics

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
