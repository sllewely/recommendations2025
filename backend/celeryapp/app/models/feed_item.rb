class FeedItem < ApplicationRecord
  belongs_to :user
  belongs_to :feedable, polymorphic: true

  scope :by_friends, ->(user_ids) { where(user_id: user_ids) }
end