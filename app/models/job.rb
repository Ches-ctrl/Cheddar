class Job < ApplicationRecord
  include PgSearch::Model

  # TODO: Number of questions in job form
  # TODO: Estimated time to complate job application based on form length/type

  # attr_accessor :company_name

  serialize :application_criteria, coder: JSON

  belongs_to :company
  belongs_to :applicant_tracking_system, optional: true

  has_many :job_applications, dependent: :destroy
  has_many :saved_jobs, dependent: :destroy
  has_many :playlist_jobs
  has_many :job_playlists, through: :playlist_jobs

  before_create :set_date_created

  validates :job_title, presence: true
  validates :job_posting_url, uniqueness: true, presence: true

  after_create :update_application_criteria
  
  # TODO: Update validate uniqueness as same job can have both a normal url and api url

  pg_search_scope :global_search,
    against: [:job_title, :salary, :job_description],
    associated_against: {
      company: [ :company_name, :company_category ]
    },
    using: {
      tsearch: { prefix: true }
    }

  # TODO: Question - set application_criteria = {} as default?

  def set_date_created
    self.date_created = Date.today
  end

  # Enables access to application_criteria via strings or symbols
  def application_criteria
    read_attribute(:application_criteria).with_indifferent_access
  end

  def update_application_criteria
    if job_posting_url.include?('greenhouse')
      extra_fields = GetFormFieldsJob.perform_later(job_posting_url)
      # p extra_fields
    else
      p "No additional fields to add"
    end
  end
end
