FactoryBot.define do
  factory :requirement do
    job
    work_eligibility { Faker::Boolean.boolean }
    difficulty { %w[easy medium hard].sample }
    no_of_qs { Faker::Number.between(from: 0, to: 30) }
    create_account { Faker::Boolean.boolean }
    resume { Faker::Boolean.boolean }
    cover_letter { Faker::Boolean.boolean }
    video_interview { Faker::Boolean.boolean }
    online_assessment { Faker::Boolean.boolean }
    first_round { Faker::Boolean.boolean }
    second_round { Faker::Boolean.boolean }
    third_round { Faker::Boolean.boolean }
    assessment_centre { Faker::Boolean.boolean }

    trait :with_job do
      association :job
    end
  end
end
