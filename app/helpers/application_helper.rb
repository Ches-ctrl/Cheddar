module ApplicationHelper
  include Pagy::Frontend

  def current_controller?(desired_controllers)
    desired_controllers.eql?(controller_name)
  end

  def user_detail
    @user_detail ||= UserDetail.find_or_initialize_by(user_id: current_user.id)
  end

  def request_referrer_path
    return unless request.referrer.present?

    referrer_uri = URI(request.referrer)
    referrer_uri.path
  end

  def filesize_in_mb(file)
    file_size_in_bytes = file.byte_size
    file_size_in_mb = (file_size_in_bytes.to_f / 1_048_576).round(2)
    "#{file_size_in_mb}mb"
  end
end
