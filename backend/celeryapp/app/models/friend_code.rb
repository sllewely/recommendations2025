class FriendCode < ApplicationRecord
  belongs_to :user

  # before_save :persist_with_random_token!

  validates_uniqueness_of :token

  def self.persist_with_random_token!(user, attempts = 10)
    retries ||= 0
    friend_code = FriendCode.new(user: user)
    friend_code.token = SecureRandom.urlsafe_base64(nil, false)
    friend_code.save!
  rescue ActiveRecord::RecordNotUnique => e
    raise if (retries += 1) > attempts

    Rails.logger.warn("random token, unlikely collision number #{retries}")
    retry
  end
end
