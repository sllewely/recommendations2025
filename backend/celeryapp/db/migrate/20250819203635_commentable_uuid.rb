class CommentableUuid < ActiveRecord::Migration[8.0]
  def up
    rename_column Comment.table_name, :commentable_id, :numeric_commentable_id
    add_column Comment.table_name, :commentable_id, :uuid
  end

  def down
    remove_column Comment.table_name, :commentable_id
    rename_column Comment.table_name, :numeric_commentable_id, :commentable_id
  end
end
