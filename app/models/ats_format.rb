class AtsFormat < ApplicationRecord
  belongs_to :applicant_tracking_system
  has_many :jobs, dependent: :destroy

  # On each ATS format you store the method for filling it in
  # May require filling in privacy notices - have that as part of any ATS format

  # -------------
  # Workable
  # -------------

  # Format I
  # -------------
  # 1. Find job_posting_url
  # 2. Add apply/ to url to get to apply page
  # 3. Fill in standard form
  # 4. Fill in additional details
  # 5. Press submit application

  # Format II
  # -------------





  # -------------
  # Greenhouse
  # -------------

  # Format I
  # -------------
  # 1. Find job_posting_url



end
