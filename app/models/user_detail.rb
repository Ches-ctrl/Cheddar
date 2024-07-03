# frozen_string_literal: true

class UserDetail < ApplicationRecord
  # == Attributes ===========================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  def full_name
    first_name = info['first_name'] || ""
    last_name = info['last_name'] || ""
    full_name = "#{first_name} #{last_name}".strip
    full_name.present? ? full_name : "No Name"
  end
  # == Constants ============================================================
  FREQUENT_ASKED_INFO_ATTRIBUTES = %w[
    first_name last_name email phone_number
    preferred_pronoun_text preferred_pronoun_select
    address_first address_second post_code city
    website_url github_profile_url linkedin_profile
    notice_period right_to_work salary_expectation_figure
    resumes[] cover_letters[]
  ].freeze
  # == Extensions ===========================================================
  serialize :info, coder: HashSerializer
  store_accessor :info, FREQUENT_ASKED_INFO_ATTRIBUTES.excluding(['resumes', 'resumes[]', 'cover_letters', 'cover_letters[]'])
  # == Instance Methods =====================================================
  # == Relationships ========================================================
  belongs_to :user
  has_many_attached :resumes
  has_many_attached :cover_letters
  # == Scopes ===============================================================
  # == Validations ==========================================================
end
