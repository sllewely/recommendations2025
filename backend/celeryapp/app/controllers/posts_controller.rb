class PostsController < ApplicationController

  def index
    user_id = params[:user_id]

    feed = FeedItem.by_friends(current_user.friend_ids).includes(feedable: [event: [:user, comments: [:user]], post: [:user, comments: [:user]], recommendation: [:user, comments: [:user]]]).order(created_at: :desc)
    feed = feed.where(user_id: user_id) if user_id
    feed = feed

    @pagy, @feed_items = pagy(feed, limit: 30)
    render json: {
      feed_items: FeedItemBlueprint.render_as_hash(@feed_items, current_user: current_user),
      pagy: @pagy,
    }, status: :ok
  end

  def show
    post_id = params[:id]
    @post = Post.includes(:user, comments: :user).find_by(id: post_id)
    if @post
      render json: PostBlueprint.render(@post), status: :ok
    else
      render json: { error: "post not found" }, status: :not_found
    end

  end

  def create
    @post = current_user.posts.new(post_params)
    begin
      ActiveRecord::Base.transaction do
        @post.save!
        @post.feed_item = FeedItem.create!(user: current_user, feedable: @post)
        current_user.friends.each do |friend|
          friend.notifications << Notification.created_a_feedable(current_user, @post)
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: @post.errors_to_s }, status: :unprocessable_content and return
    end
    current_user.friends.each do |friend|
      PushNotification.send_push_notification(
        friend,
        "New Post",
        "#{current_user.name} posted a new post",
        "https://bumblebeans.social/posts/#{commentable.id}")
    end

    render json: PostBlueprint.render(@post), status: :created
  end

  def update
    post_id = params[:id]
    post = current_user.posts.find_by(id: post_id)
    if post.nil?
      render json: { error: "post not found" }, status: :unprocessable_content and return
    end
    if post.update(post_params)
      render json: PostBlueprint.render(post), status: :ok
    else
      render json: { error: post.errors_to_s }, status: :unprocessable_content
    end
  end

  def destroy
    post_id = params[:id]
    post = current_user.posts.find_by(id: post_id)
    if !post
      render json: { error: "post not found" }, status: :not_found
      return
    end

    if post.destroy
      render json: {}, status: :no_content
    else
      render json: { error: "unable to delete" }, status: :unprocessable_content
    end
  end

  private

  def post_params
    params.permit(:title, :content)
  end

  def recommendation_params(rec_params)
    rec_params.permit(:title, :notes, :who_recommended, :rating, :status, :media_type)
  end

end
