class EmailsController < ApplicationController
  def create
    email = params[:email]

    # TODO: Update handling of emails that have already been signed up - notify user

    hubspot_service = Email::Hubspot.new
    sendgrid_service = Email::Sendgrid.new

    hubspot_response = hubspot_service.add_contact(email)
    sendgrid_response = sendgrid_service.add_contact(email)

    if sendgrid_response.status_code.to_i == 202 && hubspot_response
      sendgrid_service.send_confirmation_email(email)
      redirect_to root_path, notice: 'Subscription successful. Please check your email for confirmation.'
    else
      redirect_to root_path, alert: 'Subscription failed. Please try again later.'
    end
  end
end
