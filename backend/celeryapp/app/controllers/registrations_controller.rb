class RegistrationsController < ApplicationController
  skip_before_action :authenticate

  def create
    @user = User.new(user_params)

    if @user.save
      if admin_friend
        Friendship.create_bidirectional_friendship!(admin_friend, @user)
      end
      # send_email_verification
      render json: @user, status: :created
    else
      render json: { error: @user.errors_to_s }, status: :unprocessable_content
    end
  end

  private

  def admin_friend
    case Rails.env
    when "production"
      User.find("b6e88c0c-0082-477f-8bd7-76872fa798fd")
    when "development"
      User.find_by(name: "CeleryTesting")
    end
  end

  def user_params
    params.permit(:username, :name, :email, :password, :password_confirmation)
  end

  def send_email_verification
    UserMailer.with(user: @user).email_verification.deliver_later
  end
end
