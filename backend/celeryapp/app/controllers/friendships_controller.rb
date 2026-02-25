class FriendshipsController < ApplicationController
  class FriendRequestNotFound < StandardError
  end

  def index
    # TODO: this will need to be paginated
    search = params[:search]
    query = current_user.friends
    if search
      query = query.by_name(search)
    end

    render json: UserBlueprint.render(query, view: :authed), status: :ok
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
    PushNotification.send_push_notification(
      user,
      "New friend",
      "#{current_user.name} is your friend!",
      "/users/#{current_user.id}")
    render json: UserBlueprint.render(user, view: :authed), status: :created
    # TODO Error handling maybe?
  end

  # This is to create a map of { id: friend } for quick lookup
  def friends_map
    friend_statuses = current_user.friend_statuses
    render json: friend_statuses, status: :ok
  end
end
