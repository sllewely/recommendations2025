class NotificationsController < ApplicationController

  def index
    render json: current_user.notifications, status: :ok
  end

end
