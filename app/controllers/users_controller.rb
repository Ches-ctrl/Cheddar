require 'open-uri'
require 'yomu'

class UsersController < ApplicationController
  def show
    @user = current_user
    @job_applications = JobApplication.includes(job: [:company]).where(user_id: current_user)
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
