class JobsLocation < ApplicationRecord
  belongs_to :job
  belongs_to :location

  validates_uniqueness_of :job_id, scope: :location_id
end
