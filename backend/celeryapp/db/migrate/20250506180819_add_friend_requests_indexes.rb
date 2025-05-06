class AddFriendRequestsIndexes < ActiveRecord::Migration[8.0]
  def change
    add_index :friend_requests, :incoming_friend_id
  end
end
