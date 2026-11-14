class Notification < ApplicationRecord
  belongs_to :user

  enum :notif_type, [
    :pending_friend_request,
    :accepted_friend_request,
    :commented_on_your_commentable,
    :commented_on_a_commentable_you_are_following,
    :created_a_feedable,
    :event_invitation,
    :event_rsvp
  ]

  scope :active, -> { where(active: true) }
  scope :listed, -> { where.not(notif_type: :pending_friend_request) }

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

  VERBS = { "post" => "made", "event" => "created", "recommendation" => "shared" }.freeze

  def self.created_a_feedable(user, feedable)
    key = feedable.class.name.downcase
    Notification.new(
      message: "#{user.name} #{VERBS.fetch(key, "created")} a new #{key}",
      notif_type: Notification.notif_types[:created_a_feedable],
      extras: { user_id: user.id, "#{key}_id" => feedable.id }
    )
  end

  ###########################
  # Events

  def self.invited_to_event(user, event, invitee_id)
    Notification.new(
      user_id: invitee_id,
      message: "#{user.name} invited you to an event",
      notif_type: Notification.notif_types[:event_invitation],
      extras: { user_id: user.id, "event_id" => event.id }
    )
  end

  def self.rsvpd_to_event(user, event)
    Notification.new(
      message: "#{user.name} rsvp'd to your event",
      notif_type: Notification.notif_types[:event_rsvp],
      extras: { user_id: user.id, "event_id" => event.id }
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

end
