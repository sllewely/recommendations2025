class CommentsController < ApplicationController

  def update
    @comment = current_user.comments.find_by(id: params[:id])
    if @comment.nil?
      render json: { error: "comment not found" }, status: :not_found and return
    end
    @comment.update(body: params[:body])
    render json: CommentBlueprint.render(@comment, view: :authed), status: :ok

  end

  def create
    # TODO: Can only post on comment within friends
    @comment = current_user.comments.new(comment_params)
    commentable = @comment.commentable
    commentable_type = @comment.commentable.class.name.downcase.pluralize

    ActiveRecord::Base.transaction do
      @comment.save!
      if commentable.user_id != current_user.id
        # Notify the original author of the post
        PushNotification.send_push_notification(
          commentable.user,
          "New Comment",
          "#{current_user.name} commented on your post",
          "/#{commentable_type}/#{commentable.id}"
        )
        commentable.user.notifications << Notification.commented_on_your_commentable(current_user, commentable)
      end
      User.find(commentable.comments.pluck(:user_id).uniq).each do |user|
        next if user.id == current_user.id
        next if user.id == commentable.user_id
        PushNotification.send_push_notification(
          user,
          "New Comment",
          "#{current_user.name} commented on a post you're following",
          "/#{commentable_type}/#{commentable.id}")
        user.notifications << Notification.commented_on_a_commentable_you_are_following(current_user, commentable)
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :unprocessable_content and return
    end
    render json: CommentBlueprint.render(commentable.comments.order(:created_at), view: :authed), status: :created
  end

  private

  def comment_params
    params.permit(:body, :commentable_type, :commentable_id)
  end
end
