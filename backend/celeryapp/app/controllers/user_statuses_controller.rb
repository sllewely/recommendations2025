class UserStatusesController < ApplicationController

  def create
    @user_status = current_user.user_statuses.new(user_status_params)
    if @user_status.save
      render json: @user_status, status: :created
    else
      render json: { error: @user_status.errors.full_messages }, status: :unprocessable_content
    end
  end

  def index
    @user_statuses = UserStatus.by_friends(current_user.friends.pluck(:id))
    render json: @user_statuses
  end

  private

  def user_status_params
    params.require(:user_status).permit(:status)
  end
end
