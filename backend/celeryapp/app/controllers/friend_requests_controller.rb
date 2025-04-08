class FriendRequestsController < ApplicationController

  def create
    # TODO friend request other ways
    # validate friend code
    token = params['token']
    friend_id = params['user_id']
    render json: { error: "friend token required" }, status: :unprocessable_content and return if token.nil?
    user = FriendCode.find_by(token: token)&.user
    render json: { error: "user with friend code not found" }, status: :unprocessable_content and return if user.nil?
    render json: { error: "user with friend code not found" }, status: :unprocessable_content and return if friend_id != user.id.to_s
    ActiveRecord::Base.transaction do
      # Create friend request
      # Create notification
      # Friendship.create_bidirectional_friendship!(current_user, user)
      user.friend_requests.create!(incoming_friend_id: current_user.id)
      # current_user.notifications << Notification.accepted_friendship_notification(user)
      user.notifications << Notification.pending_friend_request(user, current_user)
    end
    # TODO: Create a friendship notification
    render json: user.public_attributes, status: :created
    # TODO Error handling maybe?
  end
end
