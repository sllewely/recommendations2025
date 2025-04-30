class CreateUserTags < ActiveRecord::Migration[8.0]
  def change
    create_table :user_tags do |t|
      t.timestamps
      t.references :user, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
    end

    add_index :user_tags, [:user_id, :tag_id], unique: true
  end
end
