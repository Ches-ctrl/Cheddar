class AttachmentsController < ApplicationController
  def destroy
    load_attachment
    destroy_attachment
  end

  private

  def destroy_attachment
    if @attachment.present?
      @attachment.purge
      success_redirect_to_referrer
    else
      error_redirect_to_referrer
    end
  end

  def load_attachment
    @attachment = ActiveStorage::Attachment.find(params.permit(:id)[:id])
  end

  def success_redirect_to_referrer
    redirect_to request.referrer, notice: 'Attachment successfully removed!'
  end

  def error_redirect_to_referrer
    redirect_to request.referrer, alert: 'Something went wrong, please try again'
  end
end
