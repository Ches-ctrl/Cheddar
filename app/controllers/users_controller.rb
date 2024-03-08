require 'open-uri'
require 'yomu'

class UsersController < ApplicationController
  def show
    @user = current_user
    @job_applications = JobApplication.includes(job: [:company]).where(user_id: @user.id)

    date_range = Date.today.beginning_of_month..Date.today.end_of_month

    @applications_this_month = @job_applications.where(created_at: date_range)

    # Create a hash where keys are the days of the month and the values indicate whether an application was submitted
    @calendar_days = date_range.map do |date|
      [date, @applications_this_month.any? { |app| app.created_at == date }]
    end.to_h
    p "The calendar days are #{@calendar_days}"
  end

  def fetch_template
    json_data = JSON.parse(request.body.read)
    filename = json_data['filename']
    p "The filename is #{filename}"
    attachment = current_user.cover_letter_templates.joins(:blob).find_by(active_storage_blobs: { filename: filename } ).url
    if attachment.present?
      # p "The file url is #{file_url}"
      # file_path = file_url.download
      # p "The file path is #{file_path}"
      yomu = Yomu.new attachment
      file_content = yomu.text

      render json: { template: file_content }
    else
      render json: { template: "File not found" }, status: :not_found
    end
  end
end

# user = User.find_by(first_name: 'Charlotte')

# # Assuming you have a Job record, find or create the job
# # Here, I'm just finding the first Job record for the sake of example
# job = Job.first

# # Create the JobApplication for the user, with the job on March 7th
# if user && job
#   JobApplication.create(
#     user_id: user.id,
#     job_id: job.id,
#     created_at: DateTime.new(2024, 3, 6),
#     updated_at: DateTime.new(2024, 3, 6),
#     status: 'applied' # or any default status you have
#   )
# else
#   puts "User or Job not found."
# end
