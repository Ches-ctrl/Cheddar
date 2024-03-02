FactoryBot.define do
  factory :job do
    job_title { Faker::Job.title }
    # job_description { Faker::Quote.most_interesting_man_in_the_world }
    # seniority { Faker::Job.seniority }
    company { association :company }
    job_posting_url { Faker::Internet.url }
    location { "#{Faker::Address.city}, #{Faker::Address.country}" }
  end
end
