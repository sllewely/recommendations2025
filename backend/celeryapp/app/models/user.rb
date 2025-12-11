class User < ApplicationRecord
  has_secure_password

  has_many :recommendations, dependent: :destroy
  has_many :posts
  has_many :events
  has_many :rsvps, dependent: :destroy
  has_many :friend_codes
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :friend_requests, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :comments
  has_many :user_tags
  has_many :tags, through: :user_tags
  has_many :user_statuses, dependent: :destroy
  has_many :groups, through: :user_groups
  has_many :web_push_registrations
  has_many :circles

  scope :by_name, ->(search) { where('LOWER(name) LIKE LOWER(?)', "%#{search}%") }
  scope :by_tag, ->(tag) { joins(:tags).where('tags.tag LIKE (?)', tag) }
  scope :by_group, ->(group) { where('groups.group LIKE (?)', group) }

  generates_token_for :email_verification, expires_in: 2.days do
    email
  end

  generates_token_for :password_reset, expires_in: 20.minutes do
    password_salt.last(10)
  end

  has_many :sessions, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  # validates :username, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, allow_nil: true, length: { minimum: 6 }

  normalizes :email, with: -> { _1.strip.downcase }

  before_validation if: :email_changed?, on: :update do
    self.verified = false
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

  def outgoing_friend_requests
    FriendRequest.where(incoming_friend_id: id)
  end

  # friends and myself
  def friend_ids
    friends.pluck(:friend_id) << id
  end

  def friend_status(user_id)
    return :self if user_id == self.id
    return :friends if self.friends.where(user_id: user_id).exists?
    return :sent_friend_request if self.outgoing_friend_requests.where(user_id: user_id).exists?
    return :pending_friend_request if self.friend_requests.where(incoming_friend_id: user_id).exists?
    :none # default otherwise
  end

  # Returns a map of user_id => friendship status
  def friend_statuses
    friends = self.friends.pluck(:id)
    received_friend_requests = self.friend_requests.pluck('friend_requests.incoming_friend_id')
    sent_friend_requests = self.outgoing_friend_requests.pluck('friend_requests.user_id')
    status_map = { self.id => :self }
    friends.each { |friend_id| status_map[friend_id] = :friends }
    received_friend_requests.each { |friend_id| status_map[friend_id] = :pending_friend_request }
    sent_friend_requests.each { |friend_id| status_map[friend_id] = :sent_friend_request }
    status_map
  end

  def update_tags(tag_names)
    # there's a bug here.  dups are being created anyway
    tags = (tag_names).map { |t| t.downcase }.map { |t| Tag.find_or_create_by(tag: t) }
    self.tags = tags
  end

  def active_notifications
    self.notifications.where('active = true').order(created_at: :desc)
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
end
