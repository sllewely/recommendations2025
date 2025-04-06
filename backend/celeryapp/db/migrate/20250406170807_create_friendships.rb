class CreateFriendships < ActiveRecord::Migration[8.0]
  def change
    create_table :friendships do |t|
      t.timestamps
      t.belongs_to :user, index: true, foreign_key: true, null: false
      t.integer :friend_id, null: false
    end

    add_index :friendships, [:user_id, :friend_id], unique: true
  end
end
