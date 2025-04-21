class CommentsController < ApplicationController

  def update
    @comment = current_user.comments.find_by(id: params[:id])
    if @comment.nil?
      render json: { error: "comment not found" }, status: :not_found and return
    end
    @comment.update(body: params[:body])
    render json: @comment, status: :ok

  end

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
