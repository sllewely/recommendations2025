class PopulateCommentableUuidForComments < ActiveRecord::Migration[8.0]
  def up
    # map for reassigning ids
    posts = Post.all.each_with_object({}) do |posts, hash|
      hash[posts.numeric_id] = posts.id
    end
    recommendations = Recommendation.all.each_with_object({}) do |recommendations, hash|
      hash[recommendations.numeric_id] = recommendations.id
    end
    events = Event.all.each_with_object({}) do |event, hash|
      hash[event.numeric_id] = event.id
    end

    Comment.all.each do |comment|
      if comment.commentable_type == 'Post'
        comment.update(commentable_id: posts[comment.numeric_commentable_id])
      elsif comment.commentable_type == 'Recommendation'
        comment.update(commentable_id: recommendations[comment.numeric_commentable_id])
      else
        comment.update(commentable_id: events[comment.numeric_commentable_id])
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'This migration cannot be reverted because column renaming needs to happen first.'
  end
end
