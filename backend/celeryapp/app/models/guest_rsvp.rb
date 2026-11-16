class GuestRsvp < ApplicationRecord
  belongs_to :guest
  belongs_to :event

  # same values as Rsvp, limited to what a guest can choose
  enum :status, { interested: 0, cant_go: 1, going: 2 }, validate: true

  validates :guest_id, uniqueness: { scope: :event_id }
end
