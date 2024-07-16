module Ats
  module Greenhouse
    module ApplicationFields
      def get_application_question_set(job, _data)
        job.build_application_question_set(form_structure: NEW_CORE_FIELDS)
        job.save
      end

      NEW_CORE_FIELDS = [
        {
          data_source: "scraping",
          section_slug: "core_fields",
          title: "Main critera",
          description: nil,
          questions: [
            {
              attribute: "first_name",
              required: true,
              label: "First Name",
              description: nil,
              fields: [
                {
                  id: nil,
                  selector: "first_name",
                  type: 'input_text',
                  max_length: 50,
                  options: []
                }
              ]
            },
            {
              attribute: "last_name",
              required: true,
              label: "Last Name",
              description: nil,
              fields: [
                {
                  id: nil,
                  selector: "last_name",
                  type: 'input_text',
                  max_length: 50,
                  options: []
                }
              ]
            },
            {
              attribute: "email",
              required: true,
              label: "Email",
              description: nil,
              fields: [
                {
                  id: nil,
                  selector: "email",
                  type: 'input_text',
                  max_length: 50,
                  options: []
                }
              ]
            },
            {
              attribute: "phone_number",
              required: true,
              label: "Phone Number",
              description: nil,
              fields: [
                {
                  id: nil,
                  selector: "phone",
                  type: 'input_text',
                  max_length: 15,
                  options: []
                }
              ]
            },
            {
              attribute: "city_applicant",
              required: true,
              label: "Location (City)",
              description: nil,
              fields: [
                {
                  id: nil,
                  selector: "location",
                  type: 'input_text',
                  max_length: 50,
                  options: []
                }
              ]
            },
            {
              attribute: "resume",
              required: true,
              label: "Resume/CV",
              description: nil,
              fields: [
                {
                  id: nil,
                  selector: 'button[aria-describedby="resume-allowable-file-types"]',
                  type: "input_file",
                  max_length: nil,
                  options: []
                }
              ]
            },
            {
              attribute: "cover_letter",
              required: true,
              label: "Cover Letter",
              description: nil,
              fields: [
                {
                  id: nil,
                  selector: 'button[aria-describedby="cover_letter-allowable-file-types"]',
                  type: "input_file",
                  max_length: nil,
                  options: []
                }
              ]
            }
          ]
        }
      ]

      CORE_FIELDS = {
        first_name: {
          interaction: :input,
          locators: 'first_name',
          required: true,
          label: 'First Name',
          core_field: true
        },
        last_name: {
          interaction: :input,
          locators: 'last_name',
          required: true,
          label: 'Last Name',
          core_field: true
        },
        email: {
          interaction: :input,
          locators: 'email',
          required: true,
          label: 'Email',
          core_field: true
        },
        phone_number: {
          interaction: :input,
          locators: 'phone',
          required: true,
          label: 'Phone',
          core_field: true
        },
        city: {
          interaction: :input,
          locators: 'location',
          required: false,
          label: 'Location (City)',
          core_field: true
        },
        resume: {
          interaction: :upload,
          locators: 'button[aria-describedby="resume-allowable-file-types"]',
          required: true,
          label: 'Resume/CV',
          core_field: true
        },
        cover_letter_: {
          interaction: :upload,
          locators: 'button[aria-describedby="cover_letter-allowable-file-types"]',
          required: true,
          label: 'Cover Letter',
          core_field: true
        }
      }

      ADDITIONAL_FIELDS = {
        school: {
          interaction: :select,
          locators: 's2id_education_school_name_0',
          required: true,
          placeholder: 'Select a School',
          data_url: 'https://boards-api.greenhouse.io/v1/boards/phonepe/education/schools',
          label: 'School',
          core_field: false
        },
        degree: {
          interaction: :select,
          locators: 's2id_education_degree_0',
          required: false,
          label: 'Degree',
          core_field: false
        },
        discipline: {
          interaction: :select,
          locators: 's2id_education_discipline_0',
          required: false,
          label: 'Discipline',
          core_field: false
        },
        ed_start_date_year: {
          interaction: :input,
          locators: 'job_application[educations][][start_date][year]',
          required: true,
          label: 'Education Start Date Year',
          core_field: false
        },
        ed_end_date_year: {
          interaction: :input,
          locators: 'job_application[educations][][end_date][year]',
          required: true,
          label: 'Education End Date Year',
          core_field: false
        },
        company_name: {
          interaction: :input,
          locators: 'job_application[employments][][company_name]',
          required: true,
          label: 'Company Name',
          core_field: false
        },
        title: {
          interaction: :input,
          locators: 'job_application[employments][][title]',
          required: true,
          label: 'Title',
          core_field: false
        },
        emp_start_date_month: {
          interaction: :input,
          locators: 'job_application[employments][][start_date][month]',
          required: true,
          label: 'Employment Start Date Month',
          core_field: false
        },
        emp_start_date_year: {
          interaction: :input,
          locators: 'job_application[employments][][start_date][year]',
          required: true,
          label: 'Employment Start Date Year',
          core_field: false
        },
        emp_end_date_month: {
          interaction: :input,
          locators: 'job_application[employments][][end_date][month]',
          required: true,
          label: 'Employment End Date Month',
          core_field: false
        },
        emp_end_date_year: {
          interaction: :input,
          locators: 'job_application[employments][][end_date][year]',
          required: true,
          label: 'Employment End Date Year',
          core_field: false
        },
        linkedin_profile: {
          interaction: :input,
          locators: 'input[autocomplete="custom-question-linkedin-profile"]',
          required: false,
          label: 'LinkedIn Profile',
          core_field: false
        },
        personal_website: {
          interaction: :input,
          locators: 'input[autocomplete="custom-question-website"], input[autocomplete="custom-question-portfolio-linkwebsite"]',
          required: false,
          label: 'Personal Website',
          core_field: false
        },
        gender: {
          interaction: :input,
          locators: 'input[autocomplete="custom-question-website"], input[autocomplete="custom-question-portfolio-linkwebsite"]',
          required: false,
          label: 'Gender',
          core_field: false
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
