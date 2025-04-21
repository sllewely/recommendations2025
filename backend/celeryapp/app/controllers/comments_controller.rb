class CommentsController < ApplicationController

  # def update
  #   @recommendation = current_user.recommendations.find(params[:id])
  #   if @recommendation.nil?
  #     render json: { error: "recommendation not found" }, status: :not_found and return
  #   end
  #   @recommendation.update(recommendation_params)
  #   render json: @recommendation.attributes, status: :ok
  #
  # end

  def create
    # TODO: Can only post on comment within friends
    @comment = current_user.comments.new(comment_params)
    if @comment.save
      render json: @comment, status: :created
    else
      render json: { error: @comment.errors_to_s }, status: :unprocessable_content
    end
  end

  private

  def comment_params
    params.permit(:body, :commentable_type, :commentable_id)
  end
end
