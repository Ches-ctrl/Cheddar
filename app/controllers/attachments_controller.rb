class AttachmentsController < ApplicationController
  def destroy
    load_attachment
    destroy_attachment
  end

  private

  def destroy_attachment
    if @attachment.present?
      @attachment.purge
      success_redirect_to_referrer('Attachment successfully removed!')
    else
      error_redirect_to_referrer('Something went wrong, please try again')
    end
  end

  def load_attachment
    @attachment = ActiveStorage::Attachment.find(params.permit(:id)[:id])
  end
end
