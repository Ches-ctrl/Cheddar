FactoryBot.define do
  factory :job do
    job_title { Faker::Job.title }
    company { association :company }
    job_posting_url { Faker::Internet.url }
    application_deadline { Date.today + 15.days }
    roles { Array.new(rand(1..3)) { association :role } }
    application_criteria { {} }

    trait :in_london do
      after(:create) do |job, evaluator|
        london = Location.find_by(city: 'London') || create(:location, city: 'London')
        create(:jobs_location, job: job, location: london)
      end
    end

    trait :entry_level_mobile do
      seniority { 'Entry-Level' }
      roles { [association(:role, name: 'mobile')] }
    end

    trait :junior_dev_ops do
      seniority { 'Junior' }
      roles { [association(:role, name: 'dev_ops')] }
    end

    trait :mid_level_data do
      seniority { 'Mid-Level' }
      roles { [association(:role, name: 'data_engineer')] }
    end

    trait :senior_front_end do
      seniority { 'Senior' }
      after(:build) do |job|
        job.roles << Role.find_or_create_by(name: 'front_end')
      end
    end

    trait :ruby_front_end do
      job_description { 'Ruby on Rails' }
      after(:build) do |job|
        job.roles << Role.find_or_create_by(name: 'front_end')
      end
    end
  end
end
