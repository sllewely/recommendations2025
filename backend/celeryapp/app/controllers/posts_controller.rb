class PostsController < ApplicationController

  skip_before_action :authenticate, only: [:rss]

  def index
    user_id = params[:user_id]

    feed = feed_items
    feed = feed.where(user_id: user_id) if user_id

    # TODO: privacy
    @pagy, @feed_items = pagy(feed, limit: 30)
    render json: {
      feed_items: FeedItemBlueprint.render_as_hash(@feed_items, current_user: current_user),
      pagy: @pagy,
    }, status: :ok
  end

  def rss
    # get rss api key
    current_user = User.find_by(rss_api_key: params[:rss_api_key])
    render json: { error: "Invalid RSS API key" }, status: :unprocessable_content and return if current_user.nil?

    feed = feed_items.limit(30)

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
        "/posts/#{@post.id}")
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
