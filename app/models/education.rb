class Education < ApplicationRecord
  include UniversityList
  belongs_to :user
end
