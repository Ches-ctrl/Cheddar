FactoryBot.define do
   factory :job do
    job_title { Faker::Job.title }
    job_posting_url { Faker::Internet.domain_name }

    association :company
  end
end
