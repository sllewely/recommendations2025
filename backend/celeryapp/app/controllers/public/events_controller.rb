class Public::EventsController < ApplicationController
  include GuestIdentity
  skip_before_action :authenticate
  rate_limit to: 20, within: 1.minute, only: :rsvp

  def show
    # Anyone can access an event with the link
    @event = Event.includes(:guest_rsvps, proposed_times: [:users, :guests]).find_by(id: params[:id])

    if @event
      render json: EventBlueprint.render(@event, view: :unauthed), status: :ok
    else
      render json: {}, status: :not_found
    end
  end

  # rsvp as a guest, without an account
  def rsvp
    @event = Event.find_by(id: params[:id])
    if @event.nil?
      render json: { error: "event not found" }, status: :not_found and return
    end

    guest_rsvp = nil
    ActiveRecord::Base.transaction do
      guest = find_or_create_guest!
      guest_rsvp = guest.guest_rsvps.find_or_initialize_by(event: @event)
      guest_rsvp.status = params[:status] || "interested"
      guest_rsvp.save!
    end

    @event.user.notifications << Notification.guest_rsvpd_to_event(current_guest, @event)
    PushNotification.send_push_notification(
      @event.user,
      "New rsvp",
      "#{current_guest.name} (guest) rsvp'd to your event #{@event.title}",
      "/events/#{@event.id}"
    )

    render json: {
      guest: GuestBlueprint.render_as_hash(current_guest, view: :self),
      rsvp: GuestRsvpBlueprint.render_as_hash(guest_rsvp, view: :unauthed),
    }, status: :created
  end
end
