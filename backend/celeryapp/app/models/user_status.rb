class UserStatus < ApplicationRecord
  belongs_to :user
  validates :status, presence: true, allow_blank: false

  scope :by_friends, -> (friend_ids) { where(user_id: friend_ids) }
end
