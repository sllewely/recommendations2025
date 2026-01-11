class FriendRequest < ApplicationRecord

  # the person receiving the friend request
  belongs_to :user
  # the person who sent the friend request
  belongs_to :incoming_friend, class_name: 'User', foreign_key: :incoming_friend_id

  validates_with CanFriendRequest, on: :create

  enum :status, { pending: 0, accepted: 1, rejected: 2 }
end


