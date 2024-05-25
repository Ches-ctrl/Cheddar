FactoryBot.define do
  factory :location do
    sequence(:city) { |n| "City-#{n}" }
    country { association :country }
  end
end
