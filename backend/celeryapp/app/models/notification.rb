class Notification < ApplicationRecord
  belongs_to :user

  enum :notif_type, [
    :pending_friend_request,
    :accepted_friend_request,
    :commented_on_your_commentable,
    :commented_on_a_commentable_you_are_following,
    :created_a_feedable
  ]

  scope :active, -> { where(active: true) }
  scope :pending_friend_requests, -> { where(notif_type: 'pending_friend_request') }

  ###########################
  # Comments

  def self.commented_on_your_commentable(user, commentable)
    key = commentable.class.name.downcase
    Notification.new(
      message: "#{user.name} commented on your #{key}",
      notif_type: Notification.notif_types[:commented_on_your_commentable],
      extras: { user_id: user.id, "#{key}_id" => commentable.id }
    )
  end

  def self.commented_on_a_commentable_you_are_following(user, commentable)
    key = commentable.class.name.downcase
    Notification.new(
      message: "#{user.name} commented on a #{key} you're following",
      notif_type: Notification.notif_types[:commented_on_a_commentable_you_are_following],
      extras: { user_id: user.id, "#{key}_id" => commentable.id }
    )
  end

  ###########################
  # Posts

  def self.created_a_feedable(user, feedable)
    key = feedable.class.name.downcase
    Notification.new(
      message: "#{user.name} created a new #{key}",
      notif_type: Notification.notif_types[:created_a_feedable],
      extras: { user_id: user.id, "#{key}_id" => feedable.id }
    )
  end

  ###########################
  # Friendships

  # @param friend is a user model
  def self.accepted_friendship_notification(friend)
    Notification.new(
      message: "#{friend.name} is now your friend!",
      notif_type: Notification.notif_types[:accepted_friend_request],
      extras: { user_id: friend.id },
    )
  end

  # TODO: rethink model
  def self.pending_friend_request(receiving_user, requesting_user)
    Notification.new(
      user_id: receiving_user.id,
      message: "You have a pending friend request from #{requesting_user.name}",
      notif_type: :pending_friend_request,
      extras: { user_id: requesting_user.id }
    )
  end

end
