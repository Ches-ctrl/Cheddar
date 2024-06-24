# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    def update
      super
    end

    protected

    def after_update_path_for(resource)
      if helpers.request_referrer_path.include?("/application_processes/")
        next_step_path(application_proccess)
      else
        edit_user_registration_path(resource)
      end
    end

    private

    def application_proccess
      ApplicationProcess.find(application_proccess_id)
    end

    def application_proccess_id
      helpers.request_referrer_path.split("/application_processes/").last
    end

    def next_step_path(application_proccess)
      edit_application_process_job_application_path(application_proccess, application_proccess.job_applications.first)
    end
  end
end
