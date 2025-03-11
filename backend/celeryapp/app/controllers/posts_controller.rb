class PostsController < ApplicationController
  def index

  end

  def show

  end

  def create

    @post = current_user.posts.new(post_params)
    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_content
    end

  end

  private

  def post_params
    params.permit(:post_title, :content, recommendations_attributes: [:title, :description, :who_recommended])
  end

  def recommendation_params
    if params.has_key?('recommendation')
      params['recommendation'].permit()
    end
  end
end
