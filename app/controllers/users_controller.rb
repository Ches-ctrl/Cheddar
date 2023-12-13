class UsersController < ApplicationController
  def show
    @user = current_user
    @job_applications = JobApplication.where(user_id: current_user)
  end
end
