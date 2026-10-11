class FeedItem < ApplicationRecord
  class InvalidAudience < StandardError; end

  belongs_to :user
  belongs_to :feedable, polymorphic: true
  has_many :feed_item_audiences, dependent: :delete_all

  # prefixed because a `public` scope would clash with Module#public
  enum :visibility, { public: 0, friends: 1, specific: 2 }, prefix: true

  scope :by_friends, ->(user_ids) { where(user_id: user_ids) }

  # Items the given user may see: own items, public items, friends-only items from
  # people who friended them, and specific items where they (or a circle they are
  # currently in) are part of the audience.
  scope :visible_to, ->(viewer) do
    viewer_id = viewer.respond_to?(:id) ? viewer.id : viewer
    where(<<~SQL, me: viewer_id, public: visibilities[:public], friends: visibilities[:friends], specific: visibilities[:specific])
      feed_items.user_id = :me
      OR feed_items.visibility = :public
      OR (feed_items.visibility = :friends AND EXISTS (
            SELECT 1 FROM friendships f
            WHERE f.user_id = feed_items.user_id AND f.friend_id = :me))
      OR (feed_items.visibility = :specific AND EXISTS (
            SELECT 1 FROM feed_item_audiences a
            WHERE a.feed_item_id = feed_items.id
              AND (a.user_id = :me
                   OR a.circle_id IN (SELECT uc.circle_id FROM user_circles uc WHERE uc.member_id = :me))))
    SQL
  end

  def visible_to?(viewer)
    return false if viewer.nil?
    return true if user_id == viewer.id || visibility_public?
    return false if new_record?

    FeedItem.visible_to(viewer).where(id: id).exists?
  end

  # Replaces the audience of this item. Users must be friends of the owner and
  # circles must belong to the owner.
  def replace_audience!(user_ids: [], circle_ids: [])
    user_ids = Array(user_ids).compact_blank.uniq
    circle_ids = Array(circle_ids).compact_blank.uniq

    invalid_users = user_ids - user.friends.where(id: user_ids).pluck(:id)
    raise InvalidAudience, "can only share with friends" if invalid_users.any?

    invalid_circles = circle_ids - Circle.where(user_id: user_id, id: circle_ids).pluck(:id)
    raise InvalidAudience, "can only share with your own circles" if invalid_circles.any?

    transaction do
      feed_item_audiences.delete_all
      now = Time.current
      rows = user_ids.map { |id| { feed_item_id: self.id, user_id: id, circle_id: nil, created_at: now, updated_at: now } } +
        circle_ids.map { |id| { feed_item_id: self.id, user_id: nil, circle_id: id, created_at: now, updated_at: now } }
      FeedItemAudience.insert_all!(rows) if rows.any?
    end
    feed_item_audiences.reset
  end

  # Narrows a users relation to the users who can see this item (e.g. for notifications).
  def viewers_among(users)
    if visibility_public?
      users
    elsif visibility_friends?
      users.where(id: Friendship.where(user_id: user_id).select(:friend_id))
    else
      direct = feed_item_audiences.where.not(user_id: nil).select(:user_id)
      circle_members = UserCircle
        .where(circle_id: feed_item_audiences.where.not(circle_id: nil).select(:circle_id))
        .select(:member_id)
      users.where(id: direct).or(users.where(id: circle_members))
    end
  end

  # [{type, id, name, members?}] for serialization to the owner
  def audience
    feed_item_audiences.includes(:user, circle: :members).map do |a|
      if a.circle
        { type: "circle", id: a.circle.id, name: a.circle.name, members: a.circle.members.map(&:name) }
      else
        { type: "user", id: a.user.id, name: a.user.name }
      end
    end
  end
end
