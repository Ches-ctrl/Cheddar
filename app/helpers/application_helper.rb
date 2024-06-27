module ApplicationHelper
  include Pagy::Frontend

  def current_controller?(desired_controllers)
    desired_controllers.eql?(controller_name)
  end

  def current_user_detail
    @user_detail ||= UserDetail.find_or_initialize_by(user_id: current_user.id)
  end

  def request_referrer_path
    return unless request.referrer.present?

    referrer_uri = URI(request.referrer)
    referrer_uri.path
  end
end
