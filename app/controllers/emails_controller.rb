class EmailsController < ApplicationController
  require 'sendgrid-ruby'
  include SendGrid

  def create
    email = params[:email]
    response = add_contact_to_sendgrid(email)

    if response.status_code.to_i == 202
      send_confirmation_email(email)
      redirect_to root_path, notice: 'Subscription successful. Please check your email for confirmation.'
    else
      redirect_to root_path, alert: 'Subscription failed. Please try again later.'
    end
  end

  private

  def add_contact_to_sendgrid(email)
    sg = SendGrid::API.new(api_key: ENV.fetch('SENDGRID_API_KEY'))

    data = {
      contacts: [
        {
          email: email
        }
      ]
    }

    response = sg.client.marketing.contacts.put(request_body: data.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
    response
  end

  def send_confirmation_email(email)
    from = SendGrid::Email.new(email: 'charlie@cheddar.jobs')
    to = SendGrid::Email.new(email:)
    subject = 'Cheddar sign up confirmation'
    content = SendGrid::Content.new(type: 'text/plain', value: 'Thank you for subscribing!')

    mail = SendGrid::Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV.fetch('SENDGRID_API_KEY'))
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
    response
  end
end
