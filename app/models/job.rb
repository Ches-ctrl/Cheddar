class Job < ApplicationRecord
  include Ats::Greenhouse
  include Ats::Workable
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
  validates :job_posting_url, uniqueness: true

  # before_create :find_or_create_company
  before_create :set_application_criteria
  after_create :update_application_criteria

  pg_search_scope :global_search,
    against: [:job_title, :salary, :job_description],
    associated_against: {
      company: [ :company_name, :company_category ]
    },
    using: {
      tsearch: { prefix: true }
    }

  # def find_or_create_company
  #   p "Finding or creating company"
  #   company = CompanyCreator.new(url).find_or_create_company
  #   self.company_id = company.id
  # end

  def set_application_criteria
    if job_posting_url.include?('greenhouse')
      self.application_criteria = Job::GREENHOUSE_CORE_FIELDS
    elsif job_posting_url.include?('workable')
      self.application_criteria = Job::WORKABLE_FIELDS
    else
      self.application_criteria = {}
    end
  end

  def update_application_criteria
    if job_posting_url.include?('greenhouse')
      # extra_fields = GetFormFieldsJob.perform_later(job_posting_url)
      # p extra_fields
    else
      p "No additional fields to add"
    end
  end

  # Enables access to application_criteria via strings or symbols
  def application_criteria
    read_attribute(:application_criteria).with_indifferent_access
  end
end
