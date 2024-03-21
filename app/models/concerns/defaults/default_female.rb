module Defaults
  module DefaultFemale
    extend ActiveSupport::Concern

    # TODO: Update defaults

    DEFAULT_FEMALE = {
      'first_name' => {
        'value' => "UserMissingFirst"
      },
      'last_name' => {
        'value' => "UserMissingLast"
      },
      'email' => {
        'value' => "usermissingemail@getcheddar.xyz"
      },
      'phone_number' => {
        'value' => "+447555555555"
      },
      'address_first' => {
        'value' => "99 Missing Drive"
      },
      'address_second' => {
        'value' => "Missingham"
      },
      'post_code' => {
        'value' => "M1 1MM"
      },
      'salary_expectation_text' => {
        'value' => "£30,000 - £40,000"
      },
      'right_to_work' => {
        'value' => /yes/i ## TODO
      },
      'salary_expectation_figure' => {
        'value' => 30_000
      },
      'notice_period' => {
        'value' => 12
      },
      'preferred_pronoun_select' => {
        'value' => %r{he/him}i ## TODO
      },
      'preferred_pronoun_text' => {
        'value' => 'N/A' ## TODO
      },
      'employee_referral' => {
        'value' => "no"
      },
      'city' => {
        'value' => 'London'
      },
      'address' => {
        'value' => '8 Hawksmoor Mews, E1 0DG, London, United Kingdom'
      },
      'linkedin_profile' => {
        'value' => "https://www.linkedin.com/in/ilya-obretetskiy-b5010b1b5/"
      },
      'personal_website' => {
        'value' => "https://www.ilya.com"
      },
      'require_visa?' => {
        'value' => 'No'
      },
      'heard_of_company?' => {
        'value' => /yes/i
      },
      'heard_from' => {
        'value' => 'Cheddar'
      }
    }
  end
end
