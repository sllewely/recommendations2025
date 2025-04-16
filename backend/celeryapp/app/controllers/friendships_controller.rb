class FriendshipsController < ApplicationController
  class FriendRequestNotFound < StandardError
  end

  def index
    render json: current_user.friends.map { |f| f.public_attributes }, status: :ok
  end

  def create
    friend_id = params['friend_id']
    fr = FriendRequest.find_by(user: current_user, incoming_friend_id: friend_id)
    render json: { error: "pending friend request not found" }, status: :unprocessable_content and return if fr.nil?

    user = fr.incoming_friend
    render json: { error: "user not found to accept friend request" }, status: :unprocessable_content and return if user.nil?
    ActiveRecord::Base.transaction do
      Friendship.create_bidirectional_friendship!(current_user, user)
      current_user.notifications << Notification.accepted_friendship_notification(user)
      user.notifications << Notification.accepted_friendship_notification(current_user)
      fr.delete
    end
    render json: user.public_attributes, status: :created
    # TODO Error handling maybe?
  end
end
