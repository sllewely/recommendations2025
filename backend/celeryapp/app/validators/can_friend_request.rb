class CanFriendRequest < ActiveModel::Validator
  def validate(record)
    # I already have a friend request
    if record.incoming_friend.friend_requests.where(incoming_friend_id: record.user_id).exists?
      record.errors.add(:base, "You already have a pending friend request from #{record.user.name}")
    end
    # They have one from me
    if record.user.friend_requests.where(incoming_friend_id: record.incoming_friend_id).exists?
      record.errors.add(:base, "You already have a pending friend request to #{record.incoming_friend.name}")
    end
    # We're already friends
    if record.user.friends.where(id: record.incoming_friend_id).exists?
      record.errors.add(:base, "You are already friends with #{record.user.name}")
    end

  end
end