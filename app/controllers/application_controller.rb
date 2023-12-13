class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :photo, :resume])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :address_first, :address_second, :city, :post_code, :phone_number, :github_profile_url, :website_url, :cover_letter_template_url, :photo, :resume, :linkedin_profile, :preferred_pronoun_select, :preferred_pronoun_text, :salary_expectation_figure, :right_to_work])
  end

  def user_root_path
    profile_url
  end
end
