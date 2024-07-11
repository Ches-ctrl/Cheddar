class SavedSearch < ApplicationRecord
  # == Attributes ===========================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Constants ============================================================
  # == Extensions ===========================================================
  # == Instance Methods =====================================================
  # == Relationships ========================================================
  belongs_to :user
  has_one_attached :export
  # == Scopes ===============================================================
  # == Validations ==========================================================

  def friendly_title
    title_parts = {
      employment: params["employment"]&.first,
      location: params["location"]&.first,
      seniority: "#{params['seniority']&.first} #{params['role']&.first}",
      ats: "jobs posted on #{params['ats']&.first}",
      posted: "last #{params['posted']}"
    }
    title_parts.select { |k, _v| params.keys.include?(k.to_s) }.values.map(&:titleize).join(" ")
  end
end
