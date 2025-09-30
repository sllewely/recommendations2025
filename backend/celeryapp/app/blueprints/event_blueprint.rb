class EventBlueprint < Blueprinter::Base
  identifier :id

  field :class_name do
    "Event"
  end

  view :unauthed do
    fields :id, :title, :description, :start_date_time, :event_type, :url, :user_id, :start_date_string,
           :start_time_string, :create_date_string, :create_time_string
    association :rsvps, blueprint: RsvpBlueprint, view: :unauthed
    association :user, blueprint: UserBlueprint, view: :unauthed
  end

  view :authed do
    include_view :unauthed
    field :address
    association :rsvps, blueprint: RsvpBlueprint, view: :unauthed
    field :current_user_rsvp do |event, opts|
      event.rsvp_status_for_current_user(opts[:current_user])
    end
    association :comments, blueprint: CommentBlueprint
    association :user, blueprint: UserBlueprint, view: :authed
  end
end