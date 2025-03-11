class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.timestamps
      t.string "post_title"
      t.text "content"
      t.belongs_to :user, index: true, foreign_key: true
    end
  end
end
