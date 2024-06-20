# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    def update
      super
      @user.save!
      after_update_path_for(@user)
    end

    protected

    def after_update_path_for(resource)
      edit_user_registration_path
    end
  end
end
