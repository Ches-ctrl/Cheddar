class AddJobToCheddarJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
  end

  # Peusdocode:
  # 1. User goes to a webpage for a job that isn't listed on Cheddar
  # 2. User copies the URL into a space on Cheddar that initialises this background job
  # 3. The background job scrapes the URL and adds the wireframed job to Cheddar
end
