FactoryBot.define do
  factory :job do
    job_title { Faker::Job.title }
    job_description { Faker::Quote.most_interesting_man_in_the_world }
    seniority { Faker::Job.seniority }
    company { association :company }
    application_criteria {
      {
        "first_name" => {
          "interaction" => "input",
          "locators" => "first_name",
          "required" => true
        },
        "last_name" => {
          "interaction" => "input",
          "locators" => "last_name",
          "required" => true
        },
        "email" => {
          "interaction" => "input",
          "locators" => "email",
          "required" => true
        },
        "phone_number" => {
          "interaction" => "input",
          "locators" => "phone",
          "required" => true
        },
        "city" => {
          "interaction" => "input",
          "locators" => "job_application[location]",
          "required" => true
        },
        "location_click" => {
          "interaction" => "listbox",
          "locators" => "ul#location_autocomplete-items-popup"
        },
        "resume" => {
          "interaction" => "upload",
          "locators" => "button[aria-describedby=\"resume-allowable-file-types\"",
          "required" => true
        },
        "cover_letter_" => {
          "interaction" => "upload",
          "locators" => "button[aria-describedby=\"cover_letter-allowable-file-types\"]",
          "required" => true
        }
      }
    }
    job_posting_url { Faker::Internet.url }
    location { "#{Faker::Address.city}, #{Faker::Address.country}" }
    city { Faker::Address.city }
    country { Faker::Address.country }
  end
end
