class FriendshipMailer < ApplicationMailer
  def pending_friend_request
    @user = params[:user]
    @url = 'https://https://bumblebeans.social/friends'
    mail(to: [@user.email], subject: '[Bumblebeans.social] You have a new friend request!')
  end

end
