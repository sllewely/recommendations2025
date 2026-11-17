class GuestRsvpBlueprint < Blueprinter::Base
  identifier :id
  fields :status, :guest_id

  # anyone with the event link can see who's coming
  field :guest_name do |guest_rsvp|
    guest_rsvp.guest.name
  end

  view :unauthed do
  end

  # guests' emails are saved but never sent with the event
  view :authed do
  end
end
