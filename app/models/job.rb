class Job < ApplicationRecord
  # == Constants ============================================================
  include PgSearch::Model
  include Constants::DateConversion

  PERMITTED_SEARCH_PARAMS = [:id, :page, :posted, :query, :sort, :apply_with_cheddar, { employment: [], location: [], role: [], seniority: [], ats: [] }]

  # == Attributes ===========================================================
  # == Extensions ===========================================================
  # == Relationships ========================================================
  belongs_to :applicant_tracking_system, optional: true # TODO: remove optional
  belongs_to :company
  has_one :application_question_set, dependent: :destroy
  has_one :requirement, dependent: :destroy
  has_many :job_applications, dependent: :destroy
  has_many :jobs_countries, dependent: :destroy
  has_many :jobs_locations, dependent: :destroy
  has_many :countries, through: :jobs_countries
  has_many :jobs_roles, dependent: :destroy
  has_many :locations, through: :jobs_locations
  has_many :roles, through: :jobs_roles
  has_many :saved_jobs, dependent: :destroy

  # == Validations ==========================================================
  validates :posting_url, uniqueness: true, presence: true
  validates :title, presence: true

  validate :safe_posting_url

  # == Scopes ===============================================================
  pg_search_scope :search_job,
                  against: %i[title salary description],
                  associated_against: {
                    company: %i[name industry],
                    # locations: :city,
                    countries: :name
                  },
                  using: {
                    tsearch: { prefix: true } # allow partial search
                  }

  # == Callbacks ============================================================
  after_create :set_date_created, :update_requirements, :standardize_attributes

  # == Class Methods ========================================================
  def self.including_any(params, param)
    JobFilter.new(params.except(param)).filter_and_sort
  end

  # == Instance Methods =====================================================

  private

  def set_date_created
    self.date_posted ||= Date.today
  end

  def update_requirements
    no_of_qs = application_question_set.form_structure.map { |section| section['questions'] }.flatten.count
    build_requirement(no_of_qs:)
    save
  end

  def standardize_attributes
    Standardizer::JobStandardizer.new(self).standardize
  end

  def safe_posting_url
    uri = URI.parse(posting_url)
    errors.add(:posting_url, "is not a valid HTTP/HTTPS URL") unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError
    errors.add(:posting_url, "is invalid")
  end
end
