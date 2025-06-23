class NumberIdNullable < ActiveRecord::Migration[8.0]
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

  def change
    MODELS_POINTING_TO_USERS.each do |model|
      change_column model.table_name, :numeric_user_id, :integer, null: true
    end
  end
end
