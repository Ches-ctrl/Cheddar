FactoryBot.define do
  factory :company do
    sequence(:name) { |n| "#{Faker::Company.name} #{n}" }
    ats_identifier { SecureRandom.alphanumeric(10) }
  end
end
