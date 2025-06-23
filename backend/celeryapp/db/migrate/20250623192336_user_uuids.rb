class UserUuids < ActiveRecord::Migration[8.0]
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

    # remove foreign keys pointing to users
    MODELS_POINTING_TO_USERS.each do |model|
      remove_foreign_key model.table_name, column: :user_id
    end
    # remove_foreign_key :friend_requests, column: :incoming_friend_id
    # remove_foreign_key :friendships, column: :friend_id

    # new pk for users
    rename_column :users, :id, :numeric_id
    rename_column :users, :uuid, :id

    change_pk(:users)

  end

  def down
    users = User.all.each_with_object({}) do |user, hash|
      hash[user.id] = user.numeric_id
    end

    MODELS_POINTING_TO_USERS.each do |model|
      remove_foreign_key model.table_name, column: :user_id
    end
    remove_foreign_key :friend_requests, column: :incoming_friend_id
    remove_foreign_key :friendships, column: :friend_id

    # revert pk for users
    rename_column :users, :id, :uuid
    rename_column :users, :numeric_id, :id
    change_pk(:users)
  end

  def change_pk(table)
    execute "ALTER TABLE #{table} DROP CONSTRAINT #{table}_pkey;"
    execute "ALTER TABLE #{table} ADD PRIMARY KEY (id);"
  end
end
