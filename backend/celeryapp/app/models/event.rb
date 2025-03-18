class Event < ApplicationRecord
  include DateHelper
  belongs_to :user
  has_many :rsvps

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
                }
    )
  end
end
