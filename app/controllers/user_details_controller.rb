class UserDetailsController < ApplicationController
  def edit
    load_user_detail
  end

  def update
    load_user_detail
    assign_user_detail_params
    persist_user_detail
    # attach_documents
  end

  private

  def assign_user_detail_params
    @user_detail.assign_attributes(user_detail_params)
  end

  def attach_documents
    @user_detail.resumes.attach(user_detail_params[:resumes])
  end

  def load_user_detail
    @user_detail = UserDetail.eager_load([resumes_attachments: :blob])
                             .find_or_initialize_by(user_id: current_user.id)
  end

  def persist_user_detail
    if save_user_detail
      redirect_to edit_user_details_path, notice: 'User detail successfully saved!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def save_user_detail = @user_detail.save

  def user_detail_params
    params.require(:user_detail)
          .permit(UserDetail::FREQUENT_ASKED_INFO_ATTRIBUTES)
          .merge(resumes: params.require(:user_detail)[:resumes])
          .reject { |_key, value| value.blank? }
  end
end
