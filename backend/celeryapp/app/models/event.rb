class Event < ApplicationRecord
  belongs_to :user

  def attributes
    super.merge({
                  user: user.public_attributes,
                  class_name: 'Event',
                  creator_name: user.name,
                  creator_id: user.id,
                }
    )
  end
end
