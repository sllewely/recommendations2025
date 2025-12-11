class FriendRequestsController < ApplicationController
  include PushNotification

  def show
    # What is my friend status?
    user = User.find(params[:id])

    if user.id == current_user.id
      render json: { status: :self }, status: :ok and return
    end

    # from the current user
    outgoing_friend_request = user.friend_requests.where(incoming_friend_id: current_user.id)&.first
    if outgoing_friend_request
      render json: { status: :sent_friend_request }, status: :ok and return
    end
    # to the current user
    incoming_friend_request = user.friend_requests.where(user_id: user.id)&.first
    if incoming_friend_request
      render json: { status: :pending_friend_request }, status: :ok and return
    end
    if current_user.friends.find_by(id: user.id)
      render json: { status: :friends }, status: :ok and return
    end
    render json: { status: :none }, status: :ok
  end

  # Returns the user associated with the friend request.
  # TODO: return friend request and user, so that we can reject friend requests.  Low priority
  def index
    render json: {
      incoming_friend_requests: FriendRequestBlueprint.render_as_hash(current_user.friend_requests),
      outgoing_friend_requests: FriendRequestBlueprint.render_as_hash(current_user.outgoing_friend_requests),
    }, status: :ok
  end

  def create
    friend_id = params['user_id']
    user = User.find_by(id: friend_id)
    render json: { error: "Cannot send friend request: user not found" }, status: :unprocessable_content and return if user.nil?
    render json: { error: "Cannot send friend request: it you" }, status: :unprocessable_content and return if friend_id == current_user.id
    render json: { error: "Cannot send friend request: already friends" }, status: :unprocessable_content and return if current_user.friends.find_by(id: friend_id).present?
    try do
      ActiveRecord::Base.transaction do
        user.friend_requests.create!(incoming_friend_id: current_user.id)
        user.notifications << Notification.pending_friend_request(user, current_user)
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :unprocessable_content and return
    end
    friend_request = user.friend_requests.where(incoming_friend_id: current_user.id)&.first
    FriendshipMailer.with(user: user, friend: current_user).pending_friend_request.deliver_now!
    PushNotification.send_push_notification(user, "Friend request", "You have a pending friend request from #{current_user.name}")
    PushNotification.send_push_notification(current_user, "Friend request", "You sent a pending friend request to #{user.name}")
    render json: FriendRequestBlueprint.render(friend_request), status: :created
  end
end
