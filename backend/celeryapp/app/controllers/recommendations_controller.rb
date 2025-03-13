class RecommendationsController < ApplicationController
  def index

  end

  def show

  end

  def create
    @recommendation = current_user.recommendations.new(recommendation_params)
    if @recommendation.save
      render json: @recommendation, status: :created
    else
      render json: @recommendation.errors, status: :unprocessable_content
    end

  end

  private

  def recommendation_params
    params.permit(:title, :notes, :media_type, :status, :rating, :who_recommended)
  end
end
