class FeedItem < ApplicationRecord
  belongs_to :user
  belongs_to :feedable, polymorphic: true

  scope :can_see, ->(user_ids) { where('feed_items.user_id IN (?)', user_ids) }
end