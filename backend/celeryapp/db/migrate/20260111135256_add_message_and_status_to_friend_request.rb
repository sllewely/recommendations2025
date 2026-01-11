class AddMessageAndStatusToFriendRequest < ActiveRecord::Migration[8.1]
  def change
    add_column :friend_requests, :message, :string
    add_column :friend_requests, :status, :integer, default: 0
  end
end
