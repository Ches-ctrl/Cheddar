class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true

  has_many :job_applications, dependent: :destroy
  has_many :jobs, through: :job_applications
  has_many :saved_jobs, dependent: :destroy
  has_many :educations, dependent: :destroy

  has_one_attached :photo
  has_one_attached :resume
  has_many_attached :cover_letter_templates
end
