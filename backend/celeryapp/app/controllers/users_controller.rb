class UsersController < ApplicationController

  # Create a user is a part of Registrations controller

  def index
    # TODO: this will need to be paginated
    search = params[:search]
    query = User.all
    if params[:tag]
      query = query.by_tag(params[:tag])
    end

    render json: query.by_name(search).map(&:public_attributes), status: :ok

  end

  def show
    user_id = params[:id]
    # the current user
    if current_user.id == user_id
      render json: current_user.attributes, status: :ok and return
    end
    @user = User.find_by(id: user_id)
    render json: {}, status: :not_found and return if @user.nil?

    # TODO: show something different if friend vs not
    render json: @user.public_attributes, status: :ok
  end

  def update
    if params[:id] != current_user.id
      render json: {}, status: :unauthorized and return
    end
    current_user.update(updatable_params)
    if params[:tags]
      current_user.update_tags(params[:tags])
    end
    current_user.password = params[:password] if params[:password].present?

    if current_user.save
      render json: current_user.attributes, status: :ok
    else
      render json: current_user.errors, status: :unprocessable_content
    end
  end

  private

  def updatable_params
    params.except(:password).permit(:name, :username, :email, :blurb, :tags)
  end

end