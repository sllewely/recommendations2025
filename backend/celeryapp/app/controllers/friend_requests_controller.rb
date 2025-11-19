class FriendRequestsController < ApplicationController
  include PushNotification

  def show
    # do I have a friend request to this user?
    user = User.find(params[:id])
    friend_request = user.friend_requests.where(incoming_friend_id: current_user.id)&.first
    render json: { friend_request: friend_request }, status: :ok
  end

  # Returns the user associated with the friend request.
  # TODO: return friend request and user, so that we can reject friend requests.  Low priority
  def index
    render json: {
      incoming_friend_requests: current_user.friend_requests.map { |fr| fr.incoming_friend.public_attributes },
      outgoing_friend_requests: current_user.outgoing_friend_requests.map { |fr| fr.user.public_attributes },
    }, status: :ok
  end

  def create
    friend_id = params['user_id']
    user = User.find_by(id: friend_id)
    render json: { error: "Cannot send friend request: user not found" }, status: :unprocessable_content and return if user.nil?
    render json: { error: "Cannot send friend request: already friends" }, status: :unprocessable_content and return if current_user.friends.find_by(id: friend_id).present?
    try do
      ActiveRecord::Base.transaction do
        user.friend_requests.create!(incoming_friend_id: current_user.id)
        user.notifications << Notification.pending_friend_request(user, current_user)
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :unprocessable_content and return
    end
    FriendshipMailer.with(user: user, friend: current_user).pending_friend_request.deliver_now!
    PushNotification.send_push_notification(user, "Friend request", "You have a pending friend request from #{current_user.name}")
    PushNotification.send_push_notification(current_user, "Friend request", "You sent a pending friend request to #{user.name}")
    render json: user.public_attributes, status: :created
  end
end
