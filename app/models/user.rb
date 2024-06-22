class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # == Attributes ===========================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Constants ============================================================
  FREQUENT_ASKED_INFO_ATTRIBUTES = %w[
    first_name last_name email phone_number
    preferred_pronoun_text preferred_pronoun_select
    address_first address_second post_code city
    website_url github_profile_url linkedin_profile
    current_password resume notice_period right_to_work salary_expectation_figure
  ]
  # == Extensions ===========================================================
  # == Instance Methods =====================================================
  # == Relationships ========================================================
  has_many :application_processes, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :job_applications, through: :application_processes
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
