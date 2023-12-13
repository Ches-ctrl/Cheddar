class ApplicationResponse < ApplicationRecord
  belongs_to :job_application

  def user
    job_application.user
  end

  def job
    job_application.job
  end
end
