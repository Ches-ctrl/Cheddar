FactoryBot.define do
  factory :job do
    title { Faker::Job.title }
    company { association :company }
    posting_url { Faker::Internet.url }
    deadline { Date.today + 15.days }
    roles { Array.new(rand(1..3)) { association :role } }
  end
end
