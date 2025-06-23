class UserUuidFk < ActiveRecord::Migration[8.0]
  MODELS_POINTING_TO_USERS = [
    UserTag,
    Rsvp,
    Post,
    FriendRequest,
    Friendship,
    Comment,
    Notification,
    Event,
    Recommendation,
    FriendCode,
    Session,
    UserStatus
  ]

  def up
    MODELS_POINTING_TO_USERS.each do |model|
      rename_column model.table_name, :user_id, :numeric_user_id
      add_column model.table_name, :user_id, :uuid
    end

    rename_column :friend_requests, :incoming_friend_id, :numeric_incoming_friend_id
    add_column :friend_requests, :incoming_friend_id, :uuid

    rename_column :friendships, :friend_id, :numeric_friend_id
    add_column :friendships, :friend_id, :uuid
  end

  def down
    MODELS_POINTING_TO_USERS.each do |model|
      remove_column model.table_name, :user_id
      rename_column model.table_name, :numeric_user_id, :user_id
    end

    remove_column :friend_requests, :incoming_friend_id
    rename_column :friend_requests, :numeric_incoming_friend_id, :incoming_friend_id

    remove_column :friendships, :friend_id
    rename_column :friendships, :numeric_friend_id, :friend_id
  end
end
