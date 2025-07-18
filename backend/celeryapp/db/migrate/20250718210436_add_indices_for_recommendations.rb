class AddIndicesForRecommendations < ActiveRecord::Migration[8.0]
  def change
    add_index :recommendations, [:user_id, :title, :media_type], unique: true
    add_index :rsvps, [:user_id, :event_id], unique: true
    add_index :friendships, [:user_id, :friend_id], unique: true
    add_index :user_tags, [:user_id, :tag_id], unique: true
  end
end
