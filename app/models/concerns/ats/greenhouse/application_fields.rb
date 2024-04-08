module Ats
  module Greenhouse
    module ApplicationFields
      def get_application_criteria(job)
        job.application_criteria = CORE_FIELDS
        job.save
      end

      CORE_FIELDS = {
        first_name: {
          interaction: :input,
          locators: 'first_name',
          required: true
        },
        last_name: {
          interaction: :input,
          locators: 'last_name',
          required: true
        },
        email: {
          interaction: :input,
          locators: 'email',
          required: true
        },
        phone_number: {
          interaction: :input,
          locators: 'phone',
          required: true
        },
        city: {
          interaction: :input,
          locators: 'job_application[location]',
          required: true
        },
        location_click: {
          interaction: :listbox,
          locators: 'ul#location_autocomplete-items-popup'
        },
        resume: {
          interaction: :upload,
          locators: 'button[aria-describedby="resume-allowable-file-types"',
          required: true
        },
        cover_letter: {
          interaction: :upload,
          locators: 'button[aria-describedby="cover_letter-allowable-file-types"]',
          required: true
        }
      }

      ADDITIONAL_FIELDS = {
        school: {
          interaction: :select,
          locators: 's2id_education_school_name_0',
          required: true,
          placeholder: 'Select a School',
          data_url: 'https://boards-api.greenhouse.io/v1/boards/phonepe/education/schools'
        },
        degree: {
          interaction: :select,
          locators: 's2id_education_degree_0',
          required: false
        },
        discipline: {
          interaction: :select,
          locators: 's2id_education_discipline_0',
          required: false
        },
        ed_start_date_year: {
          interaction: :input,
          locators: 'job_application[educations][][start_date][year]',
          required: true
        },
        ed_end_date_year: {
          interaction: :input,
          locators: 'job_application[educations][][end_date][year]',
          required: true
        },
        company_name: {
          interaction: :input,
          locators: 'job_application[employments][][company_name]',
          required: true
        },
        title: {
          interaction: :input,
          locators: 'job_application[employments][][title]',
          required: true
        },
        emp_start_date_month: {
          interaction: :input,
          locators: 'job_application[employments][][start_date][month]',
          required: true
        },
        emp_start_date_year: {
          interaction: :input,
          locators: 'job_application[employments][][start_date][year]',
          required: true
        },
        emp_end_date_month: {
          interaction: :input,
          locators: 'job_application[employments][][end_date][month]',
          required: true
        },
        emp_end_date_year: {
          interaction: :input,
          locators: 'job_application[employments][][end_date][year]',
          required: true
        },
        linkedin_profile: {
          interaction: :input,
          locators: 'input[autocomplete="custom-question-linkedin-profile"]',
          required: false
        },
        personal_website: {
          interaction: :input,
          locators: 'input[autocomplete="custom-question-website"], input[autocomplete="custom-question-portfolio-linkwebsite"]',
          required: false
        },
        gender: {
          interaction: :input,
          locators: 'input[autocomplete="custom-question-website"], input[autocomplete="custom-question-portfolio-linkwebsite"]',
          required: false
        }
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

      DEGREE_OPTIONS = [
        "High School",
        "Associate's Degree",
        "Bachelor's Degree",
        "Master's Degree",
        "Master of Business Administration (M.B.A.)",
        "Juris Doctor (J.D.)",
        "Doctor of Medicine (M.D.)",
        "Doctor of Philosophy (Ph.D.)",
        "Engineer's Degree",
        "Other"
      ]

      DISCIPLINE_OPTIONS = [
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
        "Other"
      ]
    end
  end
end
