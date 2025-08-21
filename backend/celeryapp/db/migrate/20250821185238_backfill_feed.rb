class BackfillFeed < ActiveRecord::Migration[8.0]
  def up
    posts = Post.all.map do |post|
      {
        feedable_id: post.id,
        feedable_type: "Post",
        user_id: post.user_id
      }
    end
    FeedItem.insert_all(posts)
    events = Event.all.map do |event|
      {
        feedable_id: event.id,
        feedable_type: "Event",
        user_id: event.user_id
      }
    end
    FeedItem.insert_all(events)
    recommendations = Recommendation.all.map do |recommendation|
      {
        feedable_id: recommendation.id,
        feedable_type: "Recommendation",
        user_id: recommendation.user_id
      }
    end
    FeedItem.insert_all(recommendations)
  end

  def down
    FeedItem.delete_all
  end
end
