class FriendRequest < ApplicationRecord
  belongs_to :user
  belongs_to :incoming_friend, class_name: 'User', foreign_key: :incoming_friend_id

end
