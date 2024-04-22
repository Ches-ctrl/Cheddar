class Job < ApplicationRecord
  include PgSearch::Model

  # TODO: Number of questions in job form
  # TODO: Estimated time to complate job application based on form length/type

  serialize :application_criteria, coder: JSON

  belongs_to :company
  belongs_to :applicant_tracking_system, optional: true # TODO: remove optional

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

  validates :job_posting_url, uniqueness: true, presence: true
  validates :title, presence: true

  # after_create :update_application_criteria

  # TODO: Update validate uniqueness as same job can have both a normal url and api url

  pg_search_scope :search_job,
                  against: %i[title salary job_description],
                  associated_against: {
                    company: %i[name industry],
                    # locations: :city,
                    countries: :name
                  },
                  using: {
                    tsearch: { prefix: true } # allow partial search
                  }

  # TODO: Question - set application_criteria = {} as default?

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

  CONVERT_TO_DAYS = {
    'today' => 0,
    '3-days' => 3,
    'week' => 7,
    'month' => 30,
    'any-time' => 99_999
  }

  # TODO: Handle remote jobs

  def self.filter_and_sort(params)
    filters = {
      date_created: filter_by_when_posted(params[:posted]),
      seniority: filter_by_seniority(params[:seniority]),
      locations: filter_by_location(params[:location]),
      roles: filter_by_role(params[:role]),
      employment_type: filter_by_employment(params[:type]),
      company: params[:company]&.split
    }.compact

    associations = build_associations(params)
    jobs = joins(associations).where(filters)
    params[:query].present? ? jobs.search_job(params[:query]) : jobs
  end

  private

  def set_date_created
    self.date_created ||= Date.today
  end

  def update_requirements
    self.no_of_questions = application_criteria.size

    update_requirement('resume', 'req_cv')
    update_requirement('cover_letter', 'req_cover_letter')
    update_requirement('work_eligibility', 'work_eligibility')
  end

  def update_requirement(criterion_key, attribute_name)
    send("#{attribute_name}=", application_criteria.dig(criterion_key, 'required') || false)
  end

  def standardize_attributes
    Standardizer::JobStandardizer.new(self).standardize
  end

  private_class_method def self.build_associations(params)
    associations = []
    associations << :company if params.include?(:company)
    associations << :locations if params.include?(:location)
    associations << :roles if params.include?(:role)
    return associations
  end

  private_class_method def self.filter_by_when_posted(param)
    return unless param.present?

    number = CONVERT_TO_DAYS[param] || 99_999
    number.days.ago..Date.today
  end

  private_class_method def self.filter_by_location(param)
    return unless param.present?

    locations = param.split.map { |location| location.gsub('_', ' ').split.map(&:capitalize).join(' ') unless location == 'remote_only' }.compact
    { city: locations }
  end

  private_class_method def self.filter_by_role(param)
    { name: param.split } if param.present?
  end

  private_class_method def self.filter_by_seniority(param)
    return unless param.present?

    param.split.map { |seniority| seniority.split('-').map(&:capitalize).join('-') }
  end

  private_class_method def self.filter_by_employment(param)
    return unless param.present?

    param.split.map { |employment| employment.gsub('_', '-').capitalize }
  end
end


# TODO: Move application_requirements into a separate table requirements so job.requirements.cv is the query
# TODO: add description_html and other html fields?
# TODO: fully reconcile job fields by back-engineering ATS APIs - requires data build prior to this

# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.bigint "company_id", null: false
# t.integer "applicant_tracking_system_id"

# t.string "posting_url"
# t.string "apply_url"
# t.string "api_url"
# t.string "ats_job_id"

# t.string "employment_type", default: "Full-time"
# t.string "seniority"
# t.string "industry"
# t.string "sub_industry"
# t.string "department"
# t.string "office"
# t.boolean "remote"
# t.boolean "hybrid"

# t.boolean "live", default: true
# t.date "date_posted"
# t.date "deadline"
# t.text "application_criteria"

# t.string "salary"
# t.integer "bonus"

# t.text "application_details"
# t.text "responsibilities"
# t.text "requirements"
# t.text "benefits"
# t.text "responsibilities_html"
# t.text "requirements_html"
# t.text "benefits_html"

# t.index ["company_id"], name: "index_jobs_on_company_id"

# t.boolean "work_eligibility", default: true

# t.boolean "apply_with_cheddar", default: false
# t.integer "applicants_count", default: 0
# t.integer "cheddar_applicants_count", default: 0

# t.string "non_geocoded_location_string"

# t.integer "no_of_questions", default: 0
# t.boolean "create_account", default: false
# t.boolean "req_cv", default: true
# t.boolean "req_cover_letter", default: false
# t.boolean "req_video_interview", default: false
# t.boolean "req_online_assessment", default: false
# t.boolean "req_first_round", default: true
# t.boolean "req_second_round", default: true
# t.boolean "req_assessment_centre", default: false
