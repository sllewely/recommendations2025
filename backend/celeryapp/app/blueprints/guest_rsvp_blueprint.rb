class GuestRsvpBlueprint < Blueprinter::Base
  identifier :id
  fields :status, :guest_id

  view :unauthed do
  end

  view :authed do
    field :guest_name do |guest_rsvp|
      guest_rsvp.guest.name
    end
    # only the host sees guests' emails
    field :guest_email, if: ->(_field, guest_rsvp, options) { options[:current_user]&.id == guest_rsvp.event.user_id } do |guest_rsvp|
      guest_rsvp.guest.email
    end
  end
end
