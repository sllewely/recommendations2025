class NullableFriendshipNumericRelations < ActiveRecord::Migration[8.0]
  def change
    change_column_null :friendships, :numeric_friend_id, true
    change_column_null :friend_requests, :numeric_incoming_friend_id, true
  end
end
