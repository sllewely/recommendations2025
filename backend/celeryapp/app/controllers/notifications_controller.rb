class NotificationsController < ApplicationController

  def index
    render json: current_user.notifications, status: :ok
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

  private

  def notif_params
    params.permit(:active)
  end

end
