FactoryBot.define do
  factory :company do
    sequence(:name) { |n| "#{Faker::Company.name} #{n}" }
  end
end
