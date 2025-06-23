class AddUuiToAllTables < ActiveRecord::Migration[8.0]
  TABLES = [:users, :posts, :comments, :friend_requests, :friendships, :notifications, :events, :recommendations, :tags, :rsvps, :user_statuses, :user_tags, :post_recommendations, :friend_codes, :sessions]

  def up
    TABLES.each do |table|
      add_column table, :uuid, :uuid, default: "gen_random_uuid()", null: false
      add_index table, :uuid, unique: true
    end
  end

  def down
    TABLES.each do |table|
      remove_column table, :uuid
    end
  end
end
