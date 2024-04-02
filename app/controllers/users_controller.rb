require 'open-uri'
require 'yomu'

class UsersController < ApplicationController
  def show
    @user = current_user
    @job_applications = JobApplication.includes(job: [:company]).where(user_id: @user.id)

    date_range = Date.today.beginning_of_month..Date.today.end_of_month

    @applications_this_month = @job_applications.where(created_at: date_range)

    # Creates a hash where keys are the days of the month and the values indicate whether an application was submitted
    @calendar_days = date_range.to_h { |date| [date, @applications_this_month.any? { |app| app.created_at == date }] }

    # p "The calendar days are #{@calendar_days}"
    # p "The applications this month are #{@applications_this_month}"
  end

  def fetch_template
    json_data = JSON.parse(request.body.read)
    filename = json_data['filename']
    p "The filename is #{filename}"
    attachment = current_user.cover_letter_templates.joins(:blob).find_by(active_storage_blobs: { filename: }).url
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
