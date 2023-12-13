module Ats::Greenhouse
  extend ActiveSupport::Concern
  GREENHOUSE_FIELDS = {
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
    resume: {
      interaction: :upload,
      locators: 'button[aria-describedby="resume-allowable-file-types"'
    },
    city: {
      interaction: :input,
      locators: 'job_application[location]'
    },
    location_click: {
      interaction: :listbox,
      locators: 'ul#location_autocomplete-items-popup'
    },
    linkedin_profile: {
      interaction: :input,
      locators: 'input[autocomplete="custom-question-linkedin-profile"]'
    },
    personal_website: {
      interaction: :input,
      locators: 'input[autocomplete="custom-question-website"], input[autocomplete="custom-question-portfolio-linkwebsite"]'
    },
    heard_from: {
      interaction: :input,
      locators: 'input[autocomplete="custom-question-how-did-you-hear-about-this-job"]'
    },
    require_visa?: {
      interaction: :input,
      locators: 'textarea[autocomplete="custom-question-would-you-need-sponsorship-to-work-in-the-uk-"]'
    },
  }
end
