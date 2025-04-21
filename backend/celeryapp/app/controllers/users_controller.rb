class UsersController < ApplicationController

  # Create a user is a part of Registrations controller

  def index
    search = params[:search]
    render json: User.by_name(search).map(&:public_attributes), status: :ok

  end

  def show
    user_id = params[:id]
    # the current user
    if current_user.id == user_id.to_i
      render json: current_user.attributes, status: :ok and return
    end
    @user = User.find_by(id: user_id)
    render json: {}, status: :not_found and return if @user.nil?

    # TODO: show something different if friend vs not
    render json: @user.public_attributes, status: :ok
  end

  def update
    if params[:id].to_i != current_user.id
      render json: {}, status: :unauthorized and return
    end
    current_user.update(updatable_params)
    if current_user.save
      render json: current_user.attributes, status: :ok
    else
      render json: current_user.errors, status: :unprocessable_content
    end
  end

  private

  def updatable_params
    params.permit(:name, :username, :email, :blurb)
  end

end