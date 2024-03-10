class Job < ApplicationRecord
  include PgSearch::Model

  # TODO: Number of questions in job form
  # TODO: Estimated time to complate job application based on form length/type

  serialize :application_criteria, coder: JSON

  # move to locations model

  # geocoded_by :location do |obj, results|
  #   if geo = results.first
  #     obj.city = geo.city || (obj.location.split(',').first if obj.location.split(',').first != geo.country_code)
  #     obj.country = geo.country_code
  #   end
  # end

  # after_validation :geocode, if: :location_changed?

  belongs_to :company
  belongs_to :applicant_tracking_system, optional: true

  has_many :job_applications, dependent: :destroy
  has_many :saved_jobs, dependent: :destroy
  has_many :playlist_jobs
  has_many :job_playlists, through: :playlist_jobs
  has_many :jobs_locations, dependent: :destroy
  has_many :locations, through: :jobs_locations
  has_many :jobs_countries, dependent: :destroy
  has_many :countries, through: :jobs_countries

  before_create :set_date_created

  validates :job_posting_url, uniqueness: true, presence: true
  validates :job_title, presence: true,
                        uniqueness: { scope: :company_id, message: 'should be unique per company' }

  # after_create :update_application_criteria

  # TODO: Update validate uniqueness as same job can have both a normal url and api url

  pg_search_scope :search_job,
                  against: %i[job_title salary job_description],
                  associated_against: {
                    company: %i[company_name company_category],
                    locations: :city,
                    countries: :name
                  },
                  using: {
                    tsearch: { prefix: true } # allow partial search
                  }

  # TODO: Question - set application_criteria = {} as default?

  def set_date_created
    self.date_created ||= Date.today
  end

  # Enables access to application_criteria via strings or symbols
  def application_criteria
    return [] if read_attribute(:application_criteria).nil?

    read_attribute(:application_criteria).with_indifferent_access
  end

  # def update_application_criteria
  #   if job_posting_url.include?('greenhouse')
  #     extra_fields = GetFormFieldsJob.perform_later(job_posting_url)
  #     # p extra_fields
  #   else
  #     p "No additional fields to add"
  #   end
  # end

  def new_job_application_for_user(user)
    job_application = JobApplication.new(user:, job: self, status: "Pre-application")
    application_criteria.each do |field, details|
      application_response = job_application.application_responses.build(
        field_name: field,
        field_locator: details["locators"],
        interaction: details["interaction"],
        field_option: details["option"],
        required: details["required"]
      )

      # TODO: Add boolean required field (include in params and form submission page)

      application_response.field_options = details["options"] if details["options"].present?
      application_response.field_value = user.try(field) || ""
    end

    job_application
  end
end
