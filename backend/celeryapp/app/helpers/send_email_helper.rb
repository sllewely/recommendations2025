require "resend"

module SendEmailHelper

  def send_test_email(user)
    mailer = UserMailer.with(user: user).welcome_email
    mailer.deliver_now!
  end

end