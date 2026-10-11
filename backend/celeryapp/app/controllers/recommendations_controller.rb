class RecommendationsController < ApplicationController
  include PrivacyParams
  def index
    # could eventually just be a slice of my friends
    user_id = params[:user_id]
    if user_id.nil?
      render json: { error: "Error expected param user_id" }, status: :bad_request and return
    end
    recommendations = User.find(user_id).recommendations.visible_to(current_user).order(created_at: :desc)
    if params['status']
      recommendations = recommendations.where(status: params['status'])
    end

    @pagy, @recommendations = pagy(recommendations, limit: 30)
    render json: {
      recommendations: RecommendationBlueprint.render_as_hash(@recommendations, current_user: current_user),
      pagy: @pagy,
    }, status: :ok

  end

  def show
    @recommendation = Recommendation.includes(:user, comments: :user).find_by(id: params[:id])
    if @recommendation.nil? || !@recommendation.visible_to?(current_user)
      render json: { error: 'not found' }, status: :not_found and return
    end
    render json: RecommendationBlueprint.render(@recommendation, current_user: current_user), status: :ok
  end

  def update
    @recommendation = current_user.recommendations.find_by(id: params[:id])
    if @recommendation.nil?
      render json: { error: "recommendation not found" }, status: :not_found and return
    end
    privacy = privacy_params
    updated = ActiveRecord::Base.transaction do
      @recommendation.update(recommendation_params).tap { |ok| @recommendation.apply_privacy!(**privacy) if ok }
    end
    if updated
      render json: RecommendationBlueprint.render(@recommendation, current_user: current_user), status: :ok
    else
      render json: { error: @recommendation.errors_to_s }, status: :unprocessable_content
    end
  end

  def create
    privacy = privacy_params
    ActiveRecord::Base.transaction do
      @recommendation = current_user.recommendations.new(recommendation_params)
      @recommendation.save!
      @recommendation.apply_privacy!(**privacy)
      @recommendation.feed_item.viewers_among(current_user.friends).each do |friend|
        friend.notifications << Notification.created_a_feedable(current_user, @recommendation)
      end
    rescue ActiveRecord::RecordInvalid
      render json: { error: @recommendation.errors_to_s }, status: :unprocessable_content and return
    end
    render json: RecommendationBlueprint.render(@recommendation, current_user: current_user), status: :created
  end

  def destroy
    @recommendation = current_user.recommendations.find_by(id: params[:id])
    if @recommendation.nil?
      render json: { error: "recommendation not found" }, status: :not_found and return
    end
    @recommendation.destroy
    render json: nil, status: :no_content
  end

  private

  def recommendation_params
    params.permit(:title, :notes, :media_type, :status, :rating, :who_recommended, :url)
  end
end
