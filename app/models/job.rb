class Job < ApplicationRecord
  include Ats::Greenhouse
  include Ats::Workable
  serialize :application_criteria, JSON
  belongs_to :company
  belongs_to :applicant_tracking_system, optional: true
  belongs_to :ats_format, optional: true
  has_many :job_applications, dependent: :destroy
  has_many :saved_jobs, dependent: :destroy
  has_many :playlist_jobs
  has_many :job_playlists, through: :playlist_jobs
  before_create :set_application_criteria

  validates :job_title, presence: true
  # validates :job_posting_url, uniqueness: true

  # TODO: Add validations to job model
  # validates :applicant_tracking_system_id, :ats_format_id, presence: true

  include PgSearch::Model

  pg_search_scope :global_search,
    against: [:job_title, :salary, :job_description],
    associated_against: {
      company: [ :company_name, :company_category ]
    },
    using: {
      tsearch: { prefix: true }
    }

  def set_application_criteria
    if job_posting_url.include?('greenhouse')
      self.application_criteria = Job::GREENHOUSE_FIELDS
    elsif job_posting_url.include?('workable')
      self.application_criteria = Job::WORKABLE_FIELDS
    else
      self.application_criteria = {}
    end
  end

  # Enables access to application_criteria via strings or symbols
  def application_criteria
    read_attribute(:application_criteria).with_indifferent_access
  end
end

# Commented out as not required - converts symbols to strings in the JSONB object
# def application_criteria
#   super.transform_keys(&:to_sym)
# end
