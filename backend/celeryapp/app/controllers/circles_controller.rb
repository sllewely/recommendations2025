class CirclesController < ApplicationController

  def create
    circle = current_user.circles.new(circle_params)
    if circle.save
      render json: circle, status: :created
    else
      render json: { error: circle.errors_to_s }, status: :unprocessable_content
    end
  end

  def add
    circle = current_user.circles.find_by_id(params[:id])
    if circle.nil?
      render json: { error: "circle not found" }, status: :not_found and return
    end
    user = User.find_by_id(params[:user_id])
    if user.nil?
      render json: { error: "user not found" }, status: :not_found and return
    end

    circle.members << user
    render json: circle, status: :ok

  end

end

private

def circle_params
  params.permit(:name, member_ids: [])
end