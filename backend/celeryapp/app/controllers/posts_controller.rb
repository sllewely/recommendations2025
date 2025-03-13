class PostsController < ApplicationController
  def index

  end

  def show

  end

  def create

    begin
      @post = current_user.posts.new(post_params)
      ActiveRecord::Base.transaction do
        @post.save!
        if params.has_key?('recommendations_attributes')
          params['recommendations_attributes'].each do |rec_params|
            strong_params = recommendation_params(rec_params).merge(user_id: current_user.id)
            @post.recommendations << Recommendation.create!(strong_params)
          end
        end
      end
      render json: @post.attributes, status: :created
    rescue ActiveRecord::Rollback => e
      render json: @post.errors, status: :unprocessable_content
    end

  end

  private

  def post_params
    params.permit(:post_title, :content)
  end

  def recommendation_params(rec_params)
    rec_params.permit(:title, :description, :who_recommended, :rating, :status, :media_type)
  end
end
