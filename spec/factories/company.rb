FactoryBot.define do
   factory :company do
    company_name { Faker::Company.name }
  end
end
