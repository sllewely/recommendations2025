class FriendCode < ApplicationRecord
  belongs_to :user

  before_save :persist_with_random_token!

  validates_uniqueness_of :token

  def persist_with_random_token!(attempts = 10)
    retries ||= 0
    self.token = SecureRandom.urlsafe_base64(nil, false)
    save!
  rescue ActiveRecord::RecordNotUnique => e
    raise if (retries += 1) > attempts

    Rails.logger.warn("random token, unlikely collision number #{retries}")
    retry
  end
end
