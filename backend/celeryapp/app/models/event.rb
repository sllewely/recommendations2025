class Event < ApplicationRecord
  include DateHelper
  belongs_to :user
  # create scopes for each rsvp status
  has_many :rsvps
  has_many :guest_rsvps, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :reactions, as: :reactable, dependent: :destroy
  has_many :proposed_times, -> { order(:start_date_time) }, dependent: :destroy
  belongs_to :chosen_proposed_time, class_name: "ProposedTime", optional: true
  include Feedable

  before_save :ensure_end_time
  before_save :clear_moved_chosen_proposed_time

  validates :title, presence: true
  validates :start_date_time, presence: true

  scope :by_friends, ->(friend_ids) { where(user_id: friend_ids) }
  scope :want_to_see, ->(user_id) { includes(:rsvps).where(rsvps: { user_id: user_id, status: [:invited, :interested, :going] }) }
  # public to all of Bumblebeans (used by logged-out / community pages)
  scope :public_events, -> { where(id: FeedItem.visibility_public.where(feedable_type: "Event").select(:feedable_id)) }
  scope :upcoming, -> { where('start_date_time > ?', DateTime.now - 1.day) }
  scope :month_past_onward, -> { where('start_date_time > ?', DateTime.now - 1.month) }

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

  # replaces the proposed times with the given start times, keeping votes on times that remain
  def sync_proposed_times!(start_date_times)
    times = Array(start_date_times).filter_map { |t| Time.zone.parse(t.to_s) rescue nil }.uniq(&:to_i)
    proposed_times.each do |proposed_time|
      proposed_time.destroy! unless times.any? { |t| t.to_i == proposed_time.start_date_time.to_i }
    end
    times.each do |t|
      proposed_times.create!(start_date_time: t) unless proposed_times.any? { |pt| !pt.destroyed? && pt.start_date_time.to_i == t.to_i }
    end
    proposed_times.reset
  end

  # the host picks a winning proposed time, which becomes the event's start time
  def choose_proposed_time!(proposed_time)
    old_start = start_date_time
    # keep the event's length, unless the end was just the default end of day
    if end_date_time && end_date_time.to_i != old_start.end_of_day.to_i
      self.end_date_time = proposed_time.start_date_time + (end_date_time - old_start)
    else
      self.end_date_time = nil
    end
    self.start_date_time = proposed_time.start_date_time
    self.chosen_proposed_time = proposed_time
    save!
  end

  def total_rsvp
    self.rsvps.count
  end

  private

  # gives it an end time if it doesn't have one
  def ensure_end_time
    self.end_date_time ||= self.start_date_time.end_of_day
  end

  # the winner no longer applies if the start time was moved off of it
  def clear_moved_chosen_proposed_time
    return if chosen_proposed_time.nil?
    self.chosen_proposed_time = nil unless chosen_proposed_time.start_date_time.to_i == start_date_time.to_i
  end
end
