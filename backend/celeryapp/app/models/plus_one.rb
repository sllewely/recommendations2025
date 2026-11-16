# someone coming along with a user; just a name
class PlusOne < ApplicationRecord
  MAX_PER_USER = 10

  belongs_to :event
  belongs_to :user

  normalizes :name, with: ->(name) { name.strip }

  validates :name, presence: true, length: { maximum: 60 }
  validate :under_max_per_user, on: :create

  private

  def under_max_per_user
    if event && PlusOne.where(event: event, user: user).count >= MAX_PER_USER
      errors.add(:base, "you can add up to #{MAX_PER_USER} +1s")
    end
  end
end
