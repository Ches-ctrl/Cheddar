class Job < ApplicationRecord
  include PgSearch::Model
  include Constants::DateConversion

  serialize :application_criteria, coder: JSON

  belongs_to :company
  belongs_to :applicant_tracking_system, optional: true # TODO: remove optional

  has_one :requirement, dependent: :destroy

  has_many :job_applications, dependent: :destroy
  has_many :saved_jobs, dependent: :destroy

  has_many :playlist_jobs
  has_many :job_playlists, through: :playlist_jobs

  has_many :jobs_locations, dependent: :destroy
  has_many :locations, through: :jobs_locations

  has_many :jobs_countries, dependent: :destroy
  has_many :countries, through: :jobs_countries

  has_many :jobs_roles, dependent: :destroy
  has_many :roles, through: :jobs_roles

  after_create :set_date_created, :update_requirements, :standardize_attributes

  validates :posting_url, uniqueness: true, presence: true
  validates :title, presence: true

  validate :safe_posting_url

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

  def application_criteria
    return [] if read_attribute(:application_criteria).nil?

    read_attribute(:application_criteria).with_indifferent_access
  end

  private

  def set_date_created
    self.date_posted ||= Date.today
  end

  def update_requirements
    requirement = Requirement.create(job: self)
    requirement.no_of_qs = application_criteria.size
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

  public

  # ---------------------
  # Class Methods
  # ---------------------

  def self.filter_and_sort(params)
    filters = {
      date_posted: filter_by_when_posted(params[:posted]),
      seniority: filter_by_seniority(params[:seniority]),
      locations: filter_by_location(params[:location]),
      roles: filter_by_role(params[:role]),
      employment_type: filter_by_employment(params[:type])
    }.compact

    associations = build_associations(params)
    jobs = left_joins(associations).where(filters)
    params[:query].present? ? jobs.search_job(params[:query]) : jobs
  end

  def self.including_any(params, param)
    filter_and_sort params.except(param)
  end

  # ---------------------
  # Private Class Methods
  # ---------------------

  def self.build_associations(params)
    associations = []
    associations << :company if params.include?(:company)
    associations << :locations if params.include?(:location)
    associations << :roles if params.include?(:role)
    return associations
  end

  def self.filter_by_when_posted(param)
    return unless param.present?

    number = Constants::DateConversion::CONVERT_TO_DAYS[param] || 99_999
    number.days.ago..Date.today
  end

  def self.filter_by_location(param)
    return unless param.present?

    locations = param.split.map { |location| location.gsub('_', ' ').split.map(&:capitalize).join(' ') unless location == 'remote' }
    { city: locations }
  end

  def self.filter_by_role(param)
    { name: param.split } if param.present?
  end

  def self.filter_by_seniority(param)
    return unless param.present?

    param.split.map { |seniority| seniority.split('-').map(&:capitalize).join('-') }
  end

  def self.filter_by_employment(param)
    return unless param.present?

    param.split.map { |employment| employment.gsub('_', '-').capitalize }
  end

  private_class_method :build_associations, :filter_by_when_posted, :filter_by_location, :filter_by_role, :filter_by_seniority, :filter_by_employment
end
