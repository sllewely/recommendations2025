class UsersController < ApplicationController

  # Create a user is a part of Registrations controller

  def index

  end

  def show
    user_id = params[:id]
    # the current user
    if current_user.id == user_id.to_i
      render json: current_user.attributes, status: :ok and return
    end
    @user = User.find(user_id)
    render json: {}, status: :not_found and return if @user.nil?

    # TODO: show something different if friend vs not
    render json: @user.public_attributes, status: :ok
  end

  def update

  end

end