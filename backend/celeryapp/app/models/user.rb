class User < ApplicationRecord
  has_secure_password

  has_many :recommendations
  has_many :posts
  has_many :events
  has_many :rsvps
  has_many :friend_codes

  generates_token_for :email_verification, expires_in: 2.days do
    email
  end

  generates_token_for :password_reset, expires_in: 20.minutes do
    password_salt.last(10)
  end

  has_many :sessions, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, allow_nil: true, length: { minimum: 12 }

  normalizes :email, with: -> { _1.strip.downcase }

  before_validation if: :email_changed?, on: :update do
    self.verified = false
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

  def public_attributes
    {
      id: id,
      username: username,
      name: name
    }
  end

  def my_friend_code
    self.friend_codes.where('active = true').first_or_create!
  end

  def attributes
    super.except!('password_digest').merge!({ friend_code: my_friend_code })
  end
end
