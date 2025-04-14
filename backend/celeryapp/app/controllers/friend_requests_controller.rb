class FriendRequestsController < ApplicationController

  def index
    render json: FriendRequest.all.map { |fr| fr.incoming_friend.public_attributes }, status: :ok
  end

  def create
    friend_id = params['user_id']
    user = User.find_by(id: friend_id)
    render json: { error: "Cannot send friend request: user not found" }, status: :unprocessable_content and return if user.nil?
    # TODO: check if friend already or pending already
    ActiveRecord::Base.transaction do
      user.friend_requests.create!(incoming_friend_id: current_user.id)
      user.notifications << Notification.pending_friend_request(user, current_user)
    end
    render json: user.public_attributes, status: :created
  end
end
