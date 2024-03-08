class JobsCountry < ApplicationRecord
  belongs_to :job
  belongs_to :country
end
