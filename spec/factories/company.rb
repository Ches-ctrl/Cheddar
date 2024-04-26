FactoryBot.define do
  factory :company do
    sequence(:name) { |n| "#{Faker::Company.name} #{n}" }
    ats_identifier { Faker::Alphanumeric.unique.alphanumeric(number: 10) }
  end
end
