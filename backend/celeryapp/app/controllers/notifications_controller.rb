class NotificationsController < ApplicationController
  include PushNotification

  def index
    notifs = current_user.notifications.order(created_at: :desc)
    @pagy, @notifications = pagy(notifs, limit: 30)
    render json: {
      notifications: @notifications.map { |notif| with_friend_request(notif) },
      pagy: @pagy
    }, status: :ok
  end

  def has_active
    render json: { has_active: current_user.notifications.active.any? }, status: :ok
  end

  def update
    @notif = current_user.notifications.find_by(id: params[:id])
    render json: { error: "notif not found" }, status: :not_found and return if @notif.nil?
    if @notif.update(notif_params)
      render json: @notif, status: :ok
    else
      render json: { error: @notif.errors }, status: :unprocessable_content
    end
  end

  # This is a test endpoint to send myself a notification
  def create
    PushNotification.send_push_notification(
      current_user,
      "test notification",
      "talking to yourself again hmm",
      "/settings/notifications"
    )
    render json: {}, status: :ok
  end

  private

  # a friend request notification also gets who sent it and where the request stands now:
  # pending, ignored, accepted (the request is gone and you're friends), or nil (withdrawn)
  def with_friend_request(notif)
    json = notif.as_json
    return json unless notif.pending_friend_request?
    sender = User.find_by(id: notif.extras["user_id"])
    return json if sender.nil?

    request = current_user.friend_requests.find_by(incoming_friend_id: sender.id)
    status = if request
      request.pending? ? "pending" : "ignored"
    elsif current_user.friends.exists?(id: sender.id)
      "accepted"
    end
    json.merge("friend_request" => {
      "id" => request&.id || notif.extras["friend_request_id"],
      "status" => status,
      "message" => notif.extras["message"] || request&.message,
      "user" => UserBlueprint.render_as_hash(sender),
    })
  end

  def notif_params
    params.except(:id).permit(:active)
  end

end
