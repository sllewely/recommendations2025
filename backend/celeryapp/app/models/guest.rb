# someone who rsvps or votes without an account, remembered by a token in their browser
class Guest < ApplicationRecord
  has_secure_token :token
  has_many :guest_rsvps, dependent: :destroy
  has_many :proposed_time_guests, dependent: :destroy

  normalizes :name, with: ->(name) { name.strip }
  normalizes :email, with: ->(email) { email.strip.presence }

  validates :name, presence: true, length: { maximum: 60 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
end
