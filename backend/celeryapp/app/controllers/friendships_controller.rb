class FriendshipsController < ApplicationController

  def show

  end

  def create
    # validate friend code
    token = params['token']
    render json: { error: "friend token required" }, status: :unprocessable_content and return if token.nil?
    user = FriendCode.find_by(token: token)&.user
    render json: { error: "user with friend code not found" }, status: :unprocessable_content and return if user.nil?
    ActiveRecord::Base.transaction do
      Friendship.create_bidirectional_friendship!(current_user, user)
      current_user.notifications << Notification.accepted_friendship_notification(user)
      user.notifications << Notification.accepted_friendship_notification(current_user)
    end
    # TODO: Create a friendship notification
    render json: user.public_attributes, status: :created
    # TODO Error handling maybe?
  end

  # POST /new_request
  def new_request

  end
end
