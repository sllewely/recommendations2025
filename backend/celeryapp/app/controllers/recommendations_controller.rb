class RecommendationsController < ApplicationController
  def index
    # could eventually just be a slice of my friends
    user_id = params[:user_id]
    if user_id.nil?
      render json: { error: "Error expected param user_id" }, status: :bad_request and return
    end
    recommendations = User.find(user_id).recommendations.order(created_at: :desc)
    if params['status']
      recommendations = recommendations.where(status: params['status'])
    end

    @pagy, @recommendations = pagy(recommendations, limit: 30)
    render json: {
      recommendations: RecommendationBlueprint.render_as_hash(@recommendations),
      pagy: @pagy,
    }, status: :ok

  end

  def show
    @recommendation = Recommendation.includes(:user, comments: :user).find_by(id: params[:id])
    if @recommendation.nil?
      render json: { error: 'not found' }, status: :not_found and return
    end
    # TODO permissions
    render json: RecommendationBlueprint.render(@recommendation), status: :ok
  end

  def update
    @recommendation = current_user.recommendations.find_by(id: params[:id])
    if @recommendation.nil?
      render json: { error: "recommendation not found" }, status: :not_found and return
    end
    @recommendation.update(recommendation_params)
    render json: RecommendationBlueprint.render(@recommendation), status: :ok

  end

  def create
    ActiveRecord::Base.transaction do
      @recommendation = current_user.recommendations.new(recommendation_params)
      @recommendation.save!
      @recommendation.feed_item = FeedItem.create!(user: current_user, feedable: @recommendation)
    rescue ActiveRecord::RecordInvalid
      render json: { error: @recommendation.errors_to_s }, status: :unprocessable_content and return
    end
    render json: RecommendationBlueprint.render(@recommendation), status: :created
  end

  private

  def recommendation_params
    params.permit(:title, :notes, :media_type, :status, :rating, :who_recommended, :url)
  end
end
