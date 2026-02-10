class Event < ApplicationRecord
  include DateHelper
  belongs_to :user
  # create scopes for each rsvp status
  has_many :rsvps
  has_many :comments, as: :commentable, dependent: :destroy
  has_one :feed_item, as: :feedable, dependent: :destroy

  before_save :ensure_end_time

  validates :title, presence: true
  validates :start_date_time, presence: true

  scope :by_friends, ->(friend_ids) { where(user_id: friend_ids) }
  scope :invited, ->(user_id) { where(is_public: false).joins(:rsvps).where(rsvps: { user_id: user_id }) }
  scope :public_events, -> { where(is_public: true) }
  scope :upcoming, -> { where('start_date_time > ?', DateTime.now - 1.day) }
  scope :can_see, ->(user_id) do
    left_outer_joins(:rsvps)
      .where(
        "events.is_public = true OR events.user_id = :user_id OR(events.is_public = false AND rsvps.user_id = :user_id)",
        user_id: user_id
      )
      .distinct
  end

  def blueprint
    EventBlueprint
  end

  def rsvp_status_for_current_user(current_user)
    self.rsvps.where(user_id: current_user.id).first&.status
  end

  # Returns events, total number of rsvps, and my rsvp status
  def events_with_rsvps(current_user)
    ActiveRecord::Base.connection.select_all(
      "
        (SELECT rsvps.event_id, count(*)
         FROM rsvps
         WHERE rsvps.status IN (0, 1)
         GROUP BY rsvps.event_id)
"
    )
  end

  def events_with_my_rsvp(current_user)
    res = ActiveRecord::Base.connection.exec_query(
      "SELECT events.*, r.my_status
        FROM events LEFT JOIN (
            SELECT rsvps.event_id AS event_id, rsvps.status AS my_status
            FROM rsvps
            WHERE rsvps.user_id == #{current_user.id}
        ) r
        ON events.id = r.event_id
"
    )
  end

  def start_date_string
    get_date_string(start_date_time)
  end

  def start_time_string
    get_time_string(start_date_time)
  end

  def create_date_string
    get_date_string(created_at)
  end

  def create_time_string
    get_time_string(created_at)
  end

  def total_rsvp
    self.rsvps.count
  end

  private

  # gives it an end time if it doesn't have one
  def ensure_end_time
    self.end_date_time ||= self.start_date_time.end_of_day
  end
end
