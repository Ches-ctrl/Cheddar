class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # == Attributes ===========================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Constants ============================================================
  # == Extensions ===========================================================
  # == Instance Methods =====================================================
  # == Relationships ========================================================
  has_many :application_processes, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :job_applications, through: :application_process
  has_many :saved_jobs, dependent: :destroy
  has_many_attached :cover_letter_templates
  has_one_attached :photo
  has_one_attached :resume
  # == Scopes ===============================================================
  # == Validations ==========================================================
  validates :first_name, :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
