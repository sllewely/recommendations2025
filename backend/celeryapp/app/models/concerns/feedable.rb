module Feedable
  extend ActiveSupport::Concern

  included do
    has_one :feed_item, as: :feedable, dependent: :destroy

    feedable_type = name
    scope :visible_to, ->(viewer) do
      where(id: FeedItem.visible_to(viewer).where(feedable_type: feedable_type).select(:feedable_id))
    end
  end

  def visible_to?(viewer)
    return false if viewer.nil?
    return true if user_id == viewer.id
    return false if feed_item.nil?

    feed_item.visible_to?(viewer)
  end

  def visibility
    feed_item&.visibility || "public"
  end

  def audience
    feed_item&.audience || []
  end

  # Sets visibility + audience, creating the feed item if needed.
  # A nil visibility leaves the existing privacy (and audience) unchanged.
  # Raises FeedItem::InvalidAudience when the audience isn't allowed.
  def apply_privacy!(visibility: nil, user_ids: [], circle_ids: [])
    item = feed_item || build_feed_item(user_id: user_id)
    FeedItem.transaction do
      item.visibility = visibility if visibility.present?
      item.save! if item.new_record? || item.changed?

      if visibility.present?
        if item.visibility_specific?
          item.replace_audience!(user_ids: user_ids, circle_ids: circle_ids)
        else
          item.feed_item_audiences.delete_all
        end
      end
    end
    item
  end
end
