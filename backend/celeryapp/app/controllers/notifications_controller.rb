class NotificationsController < ApplicationController
  include PushNotification

  def index
    render json: current_user.notifications.active, status: :ok
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
    PushNotification.send_push_notification(current_user, "test notification", "talking to yourself again hmm")
    render json: {}, status: :ok
  end

  private

  def notif_params
    params.except(:id).permit(:active)
  end

end
