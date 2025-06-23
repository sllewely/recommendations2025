class BackfillFriendModels < ActiveRecord::Migration[8.0]
  def change
    # map for reassigning ids
    users = User.all.each_with_object({}) do |user, hash|
      hash[user.numeric_id] = user.id
    end

    FriendRequest.all.each do |fr|
      fr.update(incoming_friend_id: users[fr.numeric_incoming_friend_id], user_id: users[fr.numeric_user_id])
    end

    Friendship.all.each do |fs|
      fs.update(friend_id: users[fs.numeric_friend_id], user_id: users[fs.numeric_user_id])
    end

  end
end
