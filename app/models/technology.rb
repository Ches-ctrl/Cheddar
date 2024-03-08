class Technology < ApplicationRecord
  has_and_belongs_to_many :jobs

  validates :name, presence: true, uniqueness: true
end
