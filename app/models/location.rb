class Location < ApplicationRecord
  # == Attributes ===========================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Constants ============================================================
  # == Extensions ===========================================================

  # == Relationships ========================================================
  has_and_belongs_to_many :jobs, dependent: :destroy
  belongs_to :country
  # == Scopes ===============================================================
  # == Validations ==========================================================
  validates :city, presence: true, uniqueness: true

  # == Instance Methods =====================================================

  # == Private Instance Methods =============================================
  def full_presentation
    "#{city}, #{country.name}"
  end
end
