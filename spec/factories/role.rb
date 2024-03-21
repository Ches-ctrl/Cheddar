FactoryBot.define do
  factory :role do
    sequence(:name) { |n| "#{Faker::Construction.trade} #{n}" }
  end
end
