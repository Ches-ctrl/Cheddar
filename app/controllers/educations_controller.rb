require 'open-uri'
require 'json'

class EducationsController < ApplicationController
  def new
    @education = Education.new
  end

  def create
    @education = Education.new(education_params)
    @education.user = current_user
    if @education.save
      redirect_to profile_path(current_user), notice: 'Your education information was successfully added'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def education_params
    params.require(:education).permit(:university, :degree, :field_study, :graduation_year)
  end
end
