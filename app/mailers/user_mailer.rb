class UserMailer < ApplicationMailer
  default from: 'no-reply@yourdomain.com'

  def confirmation_email(email)
    @email = email
    mail(to: @email, subject: 'Subscription Confirmation')
  end
end
