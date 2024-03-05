FactoryBot.define do
  factory :company do
    sequence(:company_name) { |n| "#{Faker::Company.name} #{n}" }
  end
end
