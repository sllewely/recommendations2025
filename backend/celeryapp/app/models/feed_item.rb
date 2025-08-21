class FeedItem < ApplicationRecord
  belongs_to :user
  belongs_to :feedable, polymorphic: true

end