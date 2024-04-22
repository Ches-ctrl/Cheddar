FactoryBot.define do
  factory :job do
    title { Faker::Job.title }
    company { association :company }
    job_posting_url { Faker::Internet.url }
    application_deadline { Date.today + 15.days }
    roles { Array.new(rand(1..3)) { association :role } }
  end
end
