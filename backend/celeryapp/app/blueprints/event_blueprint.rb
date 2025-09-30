class EventBlueprint < Blueprinter::Base
  identifier :id

  view :unauthed do
    fields :title, :description, :start_date_time, :event_type, :url, :user_id, :start_date_string, :start_time_string
    association :rsvps, blueprint: RsvpBlueprint, view: :unauthed
  end

  view :authed do
    include_view :unauthed
    field :address
    association :rsvps, blueprint: RsvpBlueprint, view: :unauthed
    field :current_user_rsvp do |event, opts|
      event.rsvp_status_for_current_user(opts[:current_user])
    end
  end
end