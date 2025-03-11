class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.timestamps
      t.integer "author_id", null: false
      t.string "post_title"
      t.text "content"
      t.index ['author_id'], name: 'index_posts_on_author_id'
    end
  end
end
