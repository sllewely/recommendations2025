class RecommendationsController < ApplicationController
  def index
    # could eventually just be a slice of my friends
    user_id = params[:user_id]
    if user_id.nil?
      render json: { error: "Error expected param user_id" }, status: :bad_request and return
    end
    @recommendations = User.find(user_id).recommendations.order(created_at: :desc)
    if params['status']
      @recommendations = @recommendations.where(status: params['status'])
    end
    # TODO permission and pagination
    render json: @recommendations.limit(100).map(&:attributes), status: :ok

  end

  def show
    @recommendation = Recommendation.find_by(id: params[:id])
    if @recommendation.nil?
      render json: {}, status: :not_found and return
    end
    # TODO permissions
    render json: @recommendation.attributes, status: :ok
  end

  def update
    @recommendation = current_user.recommendations.find_by(id: params[:id])
    if @recommendation.nil?
      render json: { error: "recommendation not found" }, status: :not_found and return
    end
    @recommendation.update(recommendation_params)
    render json: @recommendation.attributes, status: :ok

  end

  def create
    @recommendation = current_user.recommendations.new(recommendation_params)
    if @recommendation.save
      render json: @recommendation, status: :created
    else
      render json: { error: @recommendation.errors_to_s }, status: :unprocessable_content
    end
  end

  private

  def recommendation_params
    params.permit(:title, :notes, :media_type, :status, :rating, :who_recommended)
  end
end
