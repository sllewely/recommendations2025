class WebPushRegistration < ApplicationRecord
  belongs_to :user

  scope :active, -> { where('expires_at IS NULL OR expires_at > ?', Time.now.utc.to_s) }

end