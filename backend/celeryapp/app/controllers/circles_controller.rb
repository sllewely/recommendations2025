class CirclesController < ApplicationController

  def create
    circle = current_user.circles.new(circle_params)
    if circle.save
      render json: circle, status: :created
    else
      render json: { error: circle.errors_to_s }, status: :unprocessable_content
    end
  end

end

private

def circle_params
  params.permit(:name)
end