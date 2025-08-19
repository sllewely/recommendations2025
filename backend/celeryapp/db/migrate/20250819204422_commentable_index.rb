class CommentableIndex < ActiveRecord::Migration[8.0]
  def change
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
