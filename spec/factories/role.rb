FactoryBot.define do
  factory :role do
    sequence(:name) { |n| "Role-#{n}" }

    trait :mobile do
      name { 'mobile' }
    end

    trait :dev_ops do
      name { 'dev_ops' }
    end

    trait :data_engineer do
      name { 'data_engineer' }
    end

    trait :front_end do
      name { 'front_end' }
    end
  end
end
