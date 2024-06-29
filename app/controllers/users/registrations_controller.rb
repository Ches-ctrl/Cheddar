# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters
    # def update
    #   super
    #   @user.save!
    # end

    protected

    # def update_resource(resource, params)
    #   llmmlml
    # end
    def after_update_path_for(resource)
      lmllmml
      edit_user_registration_path(resource)
    end
  end
end
