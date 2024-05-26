FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "First-#{n}" }
    sequence(:last_name) { |n| "Last-#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
  end
end
