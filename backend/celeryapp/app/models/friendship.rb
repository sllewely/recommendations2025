class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, :class_name => 'User'

  # after_save :create_bidirectional_friendship!

  private

  def self.create_bidirectional_friendship!(user, friend)
    ActiveRecord::Base.transaction do
      Friendship.create!(user: user, friend: friend)
      Friendship.create!(user: friend, friend: user)
    end
  end
end
