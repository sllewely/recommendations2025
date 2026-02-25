class NotificationsController < ApplicationController
  include PushNotification

  def index
    notifs = current_user.notifications.order(created_at: :desc)
    @pagy, @notifications = pagy(notifs, limit: 30)
    render json: {
      notifications: @notifications,
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
      "https://bumblebeans.social/"
    )
    render json: {}, status: :ok
  end

  private

  def notif_params
    params.except(:id).permit(:active)
  end

end
