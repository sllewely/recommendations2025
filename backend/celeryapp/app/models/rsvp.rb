class Rsvp < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum :status, [:interested, :cant_go, :going, :not_interested, :invited]

end
