class PostsController < ApplicationController
  def index
    friend_ids = current_user.friend_ids
    user_id = params[:user_id]
    posts = Post.includes(:comments).by_friends(friend_ids).order(created_at: :desc)
    posts = posts.where(user_id: user_id) if user_id
    recommendations = Recommendation.includes(:comments).by_friends(friend_ids).order(created_at: :desc)
    recommendations = recommendations.where(user_id: user_id) if user_id
    events = Event.includes(:comments, :rsvps).by_friends(friend_ids).order(created_at: :desc)
    events = events.where(user_id: user_id) if user_id
    feed = merge_by_time(posts, recommendations)
    feed = merge_by_time(feed, events)
    feed_with_attributes = feed.map do |e|
      row = e.attributes
      if (e.class.name == 'Event')
        row.merge!({ current_user_status: e.rsvp_status_for_current_user(current_user) })
      end
      row
    end
    render json: feed_with_attributes, status: :ok
  end

  def show
    post_id = params[:id]
    @post = Post.includes(:comments).by_friends(current_user.friend_ids).find_by(id: post_id)
    if @post
      render json: @post.attributes, status: :ok
    else
      render json: { error: "post not found" }, status: :not_found
    end

  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      render json: @post, status: :created
    else
      render json: { error: @post.errors_to_s }, status: :unprocessable_content
    end
  end

  def update
    post_id = params[:id]
    post = current_user.posts.find_by(id: post_id)
    if post.nil?
      render json: { error: "post not found" }, status: :unprocessable_content and return
    end
    if post.update(post_params)
      render json: post.attributes, status: :ok
    else
      render json: "error updating post", status: :unprocessable_content
    end
  end

  def create_post_with_recommendation

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
      render json: { error: @post.errors_to_s }, status: :unprocessable_content
    end

  end

  private

  def post_params
    # TODO: should have named this field title instead of post_title
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
