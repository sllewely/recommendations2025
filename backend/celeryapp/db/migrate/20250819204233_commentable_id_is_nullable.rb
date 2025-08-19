class CommentableIdIsNullable < ActiveRecord::Migration[8.0]
  def change
    change_column Comment.table_name, :numeric_commentable_id, :integer, null: true

    # nullabe sequential id for recommendations and posts
    change_column :recommendations, :numeric_id, :bigint, default: 0, null: true
    change_column :posts, :numeric_id, :bigint, default: 0, null: true
  end
end
