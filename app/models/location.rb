class Location < ApplicationRecord
  has_and_belongs_to_many :jobs, dependent: :destroy
  belongs_to :country

  validates :city, presence: true
end
