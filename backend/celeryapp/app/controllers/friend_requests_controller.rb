class FriendRequestsController < ApplicationController

  def index
    render json: FriendRequest.all.map { |fr| fr.incoming_friend.public_attributes }, status: :ok
  end

  def create
    # TODO friend request other ways
    token = params['token']
    friend_id = params['user_id']
    render json: { error: "friend token required" }, status: :unprocessable_content and return if token.nil?
    user = FriendCode.find_by(token: token)&.user
    render json: { error: "user with friend code not found" }, status: :unprocessable_content and return if user.nil?
    render json: { error: "user with friend code not found" }, status: :unprocessable_content and return if friend_id != user.id.to_s
    ActiveRecord::Base.transaction do
      user.friend_requests.create!(incoming_friend_id: current_user.id)
      user.notifications << Notification.pending_friend_request(user, current_user)
    end
    render json: user.public_attributes, status: :created
  end
end
