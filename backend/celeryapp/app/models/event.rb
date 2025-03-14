class Event < ApplicationRecord
  belongs_to :user

  # start_time is in seconds after 0
  def attributes
    super.merge({
                  user: user.public_attributes
                }
    )
  end
end
