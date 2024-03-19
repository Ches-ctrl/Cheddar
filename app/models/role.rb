class Role < ApplicationRecord
  has_many :jobs_roles, dependent: :destroy
  has_many :jobs, through: :jobs_roles

  validates :name, presence: true, uniqueness: true
end
