class RenamePostsPostTitleToTitle < ActiveRecord::Migration[8.1]
  def change
    rename_column :posts, :post_title, :title
  end
end
