class Event < ApplicationRecord
  include DateHelper
  belongs_to :user
  has_many :rsvps

  def rsvp_for_current_user(current_user)
    self.rsvps.where(user_id: current_user.user_id)
  end

  def total_rsvp
    self.rsvps.count
  end

  def attributes
    super.merge({
                  user: user.public_attributes,
                  class_name: 'Event',
                  creator_name: user.name,
                  creator_id: user.id,
                  start_date_string: get_date_string(start_date_time),
                  start_time_string: get_time_string(start_date_time),
                  create_date_string: get_date_string(created_at),
                  create_time_string: get_time_string(created_at),
                  rsvps_count: total_rsvp,
                }
    )
  end
end
