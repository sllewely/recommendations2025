class UserMailer < ApplicationMailer
  default from: 'Sarah <onboarding@bumblebeans.social>' # this domain must be verified with Resend
  def welcome_email
    @user = params[:user]
    @url = 'https://https://bumblebeans.social/sign_in'
    mail(to: ["se.llewelyn@gmail.com"], subject: 'hello world')
  end

  def password_reset
    @user = params[:user]
    @signed_id = @user.generate_token_for(:password_reset)

    mail to: @user.email, subject: "Reset your password"
  end

  def email_verification
    @user = params[:user]
    @signed_id = @user.generate_token_for(:email_verification)

    mail to: @user.email, subject: "Verify your email"
  end
end
