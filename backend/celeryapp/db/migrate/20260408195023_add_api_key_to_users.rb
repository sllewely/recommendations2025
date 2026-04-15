class AddApiKeyToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :rss_api_key, :uuid, default: "gen_random_uuid()", null: false
    add_index :users, :rss_api_key, unique: true
  end
end
