FactoryBot.define do
  factory :role do
    sequence(:name) { |n| "Role-#{n}" }
  end
end
