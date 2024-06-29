FactoryBot.define do
  factory :applicant_tracking_system do
    sequence(:name) { |n| "Ats-name-#{n}" }
  end
end
