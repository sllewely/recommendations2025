class PostsController < ApplicationController
  def index
    posts = Post.all.order(created_at: :desc).limit(25)
    recommendations = Recommendation.all.order(created_at: :desc).limit(25)
    events = Event.all.order(created_at: :desc).limit(25)
    feed = merge_by_time(posts, recommendations)
    feed = merge_by_time(feed, events)
    render json: feed.map { |e| e.attributes.merge(creator_name: e.user.name, creator_id: e.user.id) }, status: :ok
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
    rec_params.permit(:title, :notes, :who_recommended, :rating, :status, :media_type)
  end

  def merge_by_time(array1, array2)
    res = []
    index1 = 0
    index2 = 0
    while (index1 < array1.size || index2 < array2.size) do
      if index1 == array1.size
        res << array2[index2]
        index2 += 1
        next
      end
      if index2 == array2.size
        res << array1[index1]
        index1 += 1
        next
      end

      if (array1[index1].created_at > array2[index2].created_at)
        res << array1[index1]
        index1 += 1
      else
        res << array2[index2]
        index2 += 1
      end
    end
    res
  end
end
