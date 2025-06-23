class PopulateUserUuidFk < ActiveRecord::Migration[8.0]
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
    # map for reassigning ids
    users = User.all.each_with_object({}) do |user, hash|
      hash[user.numeric_id] = user.id
    end

    MODELS_POINTING_TO_USERS.each do |model|
      model.all.each do |m|
        m.update(user_id: users[m.numeric_user_id])
      end
      add_foreign_key model.table_name, :users, column: :user_id, on_delete: :cascade
    end

    FriendRequest.all.each do |fr|
      fr.update(incoming_friend_id: users[fr.numeric_incoming_friend_id])
    end

    Friendship.all.each do |fs|
      fs.update(friend_id: users[fs.numeric_friend_id])
    end

  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'This migration cannot be reverted because column renaming needs to happen first.'
  end
end
