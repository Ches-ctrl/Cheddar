class UserMailer < ApplicationMailer
  default from: 'charlie@cheddar.jobs'

  def confirmation_email(email)
    @email = email
    mail(to: @email, subject: 'Subscription Confirmation')
  end
end
