class Job < ApplicationRecord
  # include Ats::Greenhouse
  # include Ats::Workable
  # include AtsRouter
  include PgSearch::Model

  # TODO: Number of questions in job form
  # TODO: Estimated time to complate job application based on form length/type

  # attr_accessor :company_name

  serialize :application_criteria, coder: JSON

  belongs_to :company
  belongs_to :applicant_tracking_system, optional: true
  belongs_to :ats_format, optional: true

  has_many :job_applications, dependent: :destroy
  has_many :saved_jobs, dependent: :destroy
  has_many :playlist_jobs
  has_many :job_playlists, through: :playlist_jobs

  validates :job_title, presence: true
  validates :job_posting_url, uniqueness: true, presence: true

  pg_search_scope :global_search,
    against: [:job_title, :salary, :job_description],
    associated_against: {
      company: [ :company_name, :company_category ]
    },
    using: {
      tsearch: { prefix: true }
    }

  # TODO: Question - set application_criteria = {} as default?

  # Enables access to application_criteria via strings or symbols
  def application_criteria
    read_attribute(:application_criteria).with_indifferent_access
  end
end
