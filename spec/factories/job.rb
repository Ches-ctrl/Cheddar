require 'constants'

FactoryBot.define do
  factory :job do
    sequence(:title) { |n| "Title-#{n}" }
    company { association :company }
    sequence(:posting_url) { |n| "https://www.example-#{n}.com/jobs/1" }
    date_posted { (Date.today - rand(0..30).days) }
    employment_type { Constants::CategorySidebar::EMPLOYMENT_TYPES.sample }

    after(:create) do |job, evaluator|
      evaluator.roles.each { |role| job.roles << role unless job.roles.include?(role) }
      locations = create_list(:location, rand(1..3))
      job.locations += locations
      locations.each { |location| job.countries << location.country }
    end
  end

  trait :entry_level_mobile do
    seniority { 'Entry-Level' }
    after(:build) do |job, evaluator|
      evaluator.roles << Role.find_or_create_by(name: 'mobile')
    end
  end

  trait :junior_dev_ops do
    seniority { 'Junior' }
    after(:build) do |job, evaluator|
      evaluator.roles << Role.find_or_create_by(name: 'mobile')
    end
  end

  trait :mid_level_data do
    seniority { 'Mid-Level' }
    after(:build) do |job, evaluator|
      evaluator.roles << Role.find_or_create_by(name: 'data_engineer')
    end
  end

  trait :senior_front_end do
    seniority { 'Senior' }
    after(:build) do |job, evaluator|
      evaluator.roles << Role.find_or_create_by(name: 'front_end')
    end
  end

  trait :ruby_front_end do
    description { 'Ruby on Rails' }
    after(:build) do |job, evaluator|
      evaluator.roles << Role.find_or_create_by(name: 'front_end')
    end
  end

  trait :in_london do
    after(:build) do |job|
      london = Location.find_by(city: 'London') || create(:location, city: 'London')
      create(:jobs_location, job:, location: london)
    end
  end
end
