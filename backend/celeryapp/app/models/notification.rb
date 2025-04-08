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

  # TODO: rethink model
  def self.pending_friend_request(receiving_user, requesting_user)
    Notification.new(
      user_id: receiving_user.id,
      message: "You have a pending friend request from #{requesting_user.name}",
      notif_type: :pending_friend_request,
      extras: { requesting_user_id: requesting_user.id }
    )
  end
end
