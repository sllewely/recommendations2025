class User < ApplicationRecord
  has_secure_password

  has_many :recommendations
  has_many :posts
  has_many :events
  has_many :rsvps
  has_many :friend_codes
  has_many :friendships
  has_many :friends, through: :friendships
  has_many :friend_requests
  has_many :notifications
  has_many :comments

  scope :by_name, ->(search) { where('LOWER(name) LIKE LOWER(?)', "%#{search}%") }

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
  validates :password, allow_nil: true, length: { minimum: 6 }

  normalizes :email, with: -> { _1.strip.downcase }

  before_validation if: :email_changed?, on: :update do
    self.verified = false
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

  def active_notifications
    self.notifications.where('active = true').order(created_at: :desc)
  end

  def public_attributes
    {
      id: id,
      username: username,
      name: name
    }
  end

  def friend_code
    # Called safe navigation operator &.
    self.friend_codes.where('active = true').first&.token
  end

  def first_or_create_friend_code!
    token = self.friend_code
    return token if !token.nil?
    FriendCode.persist_with_random_token!(self)
    self.friend_code
  end

  def attributes
    super.except!('password_digest').merge!({ friend_code: first_or_create_friend_code! })
  end
end
