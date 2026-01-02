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
    if @comment.save
      commentable = @comment.commentable
      if (commentable.user.id != current_user.id)
        PushNotification.send_push_notification(commentable.user, "New Comment", "#{current_user.name} commented on your post")
      else
        User.find(commentable.comments.pluck(:user_id).uniq).each do |user|
          next if user.id == current_user.id
          PushNotification.send_push_notification(user, "New Comment", "#{current_user.name} commented on a post you're following")
        end
      end

      render json: CommentBlueprint.render(commentable.comments.order(:created_at), view: :authed), status: :created
    else
      render json: { error: @comment.errors_to_s }, status: :unprocessable_content
    end
  end

  private

  def comment_params
    params.permit(:body, :commentable_type, :commentable_id)
  end
end
