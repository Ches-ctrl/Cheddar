class JobsRole < ApplicationRecord
  belongs_to :job
  belongs_to :role

  validates_uniqueness_of :job_id, scope: :role_id
end
