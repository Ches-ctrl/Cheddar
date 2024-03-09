FactoryBot.define do
  factory :location do
    city { Faker::Address.city }
    country { association :country }
  end
end
