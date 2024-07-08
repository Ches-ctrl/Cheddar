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
  # Cloudinary::Utils.cloudinary_url(SavedSearch.last.export.key, resource_type: 'raw', version: '1/development')
  # "https://res.cloudinary.com/dzpupuayh/raw/upload/v1/development/mnntrgef22qhwf5lq52p99xyt3xy?_a=BACCd2Bn"
end
