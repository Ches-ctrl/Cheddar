FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }

    resume = 'public/Obretetskiy_cv.pdf'

    after(:create) do |user|
      create(:user_detail, user: user)
      user.user_detail.resumes.attach(io: File.open(resume), filename: File.basename(resume))
    end
  end
end
