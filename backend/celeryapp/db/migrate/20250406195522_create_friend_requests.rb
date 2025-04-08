class CreateFriendRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :friend_requests do |t|
      t.timestamps
      t.belongs_to :user, index: true, foreign_key: true, null: false
      t.integer :incoming_friend_id, null: false

    end

    add_index :friend_requests, [:user_id, :incoming_friend_id], unique: true
  end
end
