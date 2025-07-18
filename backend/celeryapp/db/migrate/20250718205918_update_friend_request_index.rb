class UpdateFriendRequestIndex < ActiveRecord::Migration[8.0]
  def change
    add_index :friend_requests, [:user_id, :incoming_friend_id], unique: true
  end
end
