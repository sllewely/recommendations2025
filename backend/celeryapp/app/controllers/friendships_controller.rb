class FriendshipsController < ApplicationController
  class FriendRequestNotFound < StandardError
  end

  def index
    render json: current_user.friends.map { |f| f.public_attributes }, status: :ok
  end

  def create
    friend_id = params['friend_id']
    friend_request = FriendRequest.find_by(user: current_user, incoming_friend_id: friend_id)
    render json: { error: "pending friend request not found" }, status: :unprocessable_content and return if friend_request.nil?

    user = friend_request.incoming_friend
    render json: { error: "user not found to accept friend request" }, status: :unprocessable_content and return if user.nil?
    ActiveRecord::Base.transaction do
      Friendship.create_bidirectional_friendship!(current_user, user)
      current_user.notifications << Notification.accepted_friendship_notification(user)
      user.notifications << Notification.accepted_friendship_notification(current_user)
      # clear pending friend request notifs
      current_user.notifications.active.pending_friend_requests.update_all(active: false)
      friend_request.delete
    end
    PushNotification.send_push_notification(user, "New friend", "#{current_user.name} is your friend!")
    render json: user.public_attributes, status: :created
    # TODO Error handling maybe?
  end

  # This is to create a map of { id: friend } for quick lookup
  def friends_map
    friends_m = (current_user.friends.to_a << current_user).each_with_object({}) do |friend, h|
      h[friend.id] = friend.public_attributes
    end
    render json: friends_m, status: :ok
  end
end
