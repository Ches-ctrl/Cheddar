FactoryBot.define do
  factory :job do
    sequence(:title) { |n| "Title-#{n}" }
    company { association :company }
    sequence(:posting_url) { |n| "https://www.example-#{n}.com/jobs/1" }
    # deadline { Date.today + 15.days }
    roles { Array.new(rand(1..3)) { association :role } }
    # application_criteria { {} }

    trait :in_london do
      after(:create) do |job, _evaluator|
        london = Location.find_by(city: 'London') || create(:location, city: 'London')
        create(:jobs_location, job:, location: london)
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
      description { 'Ruby on Rails' }
      after(:build) do |job|
        job.roles << Role.find_or_create_by(name: 'front_end')
      end
    end
  end
end
