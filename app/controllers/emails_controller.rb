class EmailsController < ApplicationController
  require 'sendgrid-ruby'
  include SendGrid

  def create
    email = params[:email]
    send_confirmation_email(email)
    redirect_to root_path, notice: 'Subscription successful. Please check your email for confirmation.'
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
  end
end
