class Notification < ApplicationRecord
  belongs_to :user

  enum :notif_type, [:pending_friend_request, :accepted_friend_request]

  # @param friend is a user model
  def self.accepted_friendship_notification(friend)
    Notification.new(
      message: "#{friend.name} is now your friend!",
      notif_type: Notification.notif_types[:accepted_friend_request],
      extras: { friend_id: friend.id },
    )
  end
end
