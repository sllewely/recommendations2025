class CreateFriendCodes < ActiveRecord::Migration[8.0]
  def change
    create_table :friend_codes do |t|
      t.timestamps
      t.belongs_to :user, index: true, foreign_key: true
      t.boolean :active, default: true
      t.string :token, null: false
    end
    add_index :friend_codes, :token, unique: true
  end
end
