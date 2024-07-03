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
  has_one :user_detail, dependent: :destroy

  has_many :application_processes, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :job_applications, through: :application_processes
  has_many :saved_jobs, dependent: :destroy
  # == Scopes ===============================================================
  # == Validations ==========================================================
end
