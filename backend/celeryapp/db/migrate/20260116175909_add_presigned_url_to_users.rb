class AddPresignedUrlToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :presigned_url, :string
    add_column :users, :presigned_url_expires, :datetime
    add_index :users, :presigned_url_expires
  end
end
