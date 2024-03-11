FactoryBot.define do
  factory :job do
    job_title { Faker::Job.title }
    company { association :company }
    job_posting_url { Faker::Internet.url }
    application_deadline { Date.today + 15.days }
  end
end
