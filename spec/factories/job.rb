FactoryBot.define do
  factory :job do
    job_title { Faker::Job.title }
    job_posting_url { Faker::Internet.url }
    company
 end
end
