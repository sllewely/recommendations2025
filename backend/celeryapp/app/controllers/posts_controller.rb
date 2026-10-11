class PostsController < ApplicationController
  include PrivacyParams

  skip_before_action :authenticate, only: [:rss]

  def index
    user_id = params[:user_id]

    feed = feed_items.visible_to(current_user)
    feed = feed.where(user_id: user_id) if user_id

    @pagy, @feed_items = pagy(feed, limit: 30)
    render json: {
      feed_items: FeedItemBlueprint.render_as_hash(
        @feed_items,
        current_user: current_user,
        friend_statuses: current_user&.friend_statuses
      ),
      pagy: @pagy,
    }, status: :ok
  end

  def rss
    # get rss api key
    user = User.find_by(rss_api_key: params[:rss_api_key])
    render json: { error: "Invalid RSS API key" }, status: :unprocessable_content and return if user.nil?

    feed = feed_items.visible_to(user).limit(30)

    base_url = Rails.env == "production" ? "https://bumblebeans.social" : "http://localhost:5173"

    # limit to latest 30
    # use rss gem https://github.com/ruby/rss
    rss = RSS::Maker.make("atom") do |maker|
      maker.channel.author = "celery"
      maker.channel.updated = Time.now.to_s
      maker.channel.about = "https://bumblebeans.social/posts/rss.rss"
      maker.channel.title = "Bumblebeans Social"

      feed.each do |feed_item|
        maker.items.new_item do |item|
          item.link = "#{base_url}/#{feed_item.feedable_type.downcase.pluralize}/#{feed_item.feedable_id}"
          case feed_item.feedable_type
          when "Event"
            item.title = feed_item.feedable.title
            item.summary = feed_item.feedable.description
          when "Recommendation"
            item.title = feed_item.feedable.title
            item.summary = feed_item.feedable.notes
          when "Post"
            item.title = feed_item.feedable.content.lines.first
            item.summary = feed_item.feedable.content
          end

          item.updated = feed_item.feedable.updated_at.to_s
        end
      end
    end

    render xml: rss.to_s, status: :ok
  end

  def show
    post_id = params[:id]
    @post = Post.includes(:user, comments: :user).find_by(id: post_id)
    if @post&.visible_to?(current_user)
      render json: PostBlueprint.render(
        @post,
        current_user: current_user,
        friend_statuses: current_user&.friend_statuses
      ), status: :ok
    else
      render json: { error: "post not found" }, status: :not_found
    end

  end

  def create
    @post = current_user.posts.new(post_params)
    privacy = privacy_params
    begin
      ActiveRecord::Base.transaction do
        @post.save!
        @post.apply_privacy!(**privacy)
        notify_friends.each do |friend|
          friend.notifications << Notification.created_a_feedable(current_user, @post)
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: @post.errors_to_s }, status: :unprocessable_content and return
    end
    notify_friends.each do |friend|
      PushNotification.send_push_notification(
        friend,
        "New Post",
        "#{current_user.name} posted a new post",
        "/posts/#{@post.id}")
    end

    render json: PostBlueprint.render(@post, current_user: current_user), status: :created
  end

  def update
    post_id = params[:id]
    post = current_user.posts.find_by(id: post_id)
    if post.nil?
      render json: { error: "post not found" }, status: :unprocessable_content and return
    end
    privacy = privacy_params
    updated = ActiveRecord::Base.transaction do
      post.update(post_params).tap { |ok| post.apply_privacy!(**privacy) if ok }
    end
    if updated
      render json: PostBlueprint.render(post, current_user: current_user), status: :ok
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

  # friends who are allowed to see the new post
  def notify_friends
    @notify_friends ||= @post.feed_item.viewers_among(current_user.friends).to_a
  end

  def feed_items
    FeedItem
      .includes(feedable: [event: [:user, comments: [:user]], post: [:user, comments: [:user]], recommendation: [:user, comments: [:user]]])
      .order(created_at: :desc)
  end

  def post_params
    params.permit(:title, :content)
  end

  def recommendation_params(rec_params)
    rec_params.permit(:title, :notes, :who_recommended, :rating, :status, :media_type)
  end

end
