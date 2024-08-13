FactoryBot.define do
  factory :user_detail do
    first_name { 'Pablo' }
    last_name { 'Picasso' }
    email { 'admin@example.com' }
    phone_number { '7555555555' }
    address_first { 'Shoreditch Stables North' }
    address_second { '138 Kingsland Rd' }
    post_code { 'E2 8DY' }
    city { 'London' }
    salary_expectation_figure { '£999,999' }
    notice_period { "I'm ready to go!" }
  end
end
