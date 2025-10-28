class EventBlueprint < Blueprinter::Base
  identifier :id
  fields :created_at, :start_date_time, :end_date_time

  field :class_name do
    "Event"
  end

  view :unauthed do
    fields :title, :description, :start_date_time, :event_type, :url, :user_id, :start_date_string,
           :start_time_string, :create_date_string, :create_time_string
    association :rsvps, blueprint: RsvpBlueprint, view: :unauthed
    association :user, blueprint: UserBlueprint, view: :unauthed
    association :comments, blueprint: CommentBlueprint, view: :unauthed
  end

  view :authed do
    include_view :unauthed
    field :address
    association :rsvps, blueprint: RsvpBlueprint, view: :authed
    association :comments, blueprint: CommentBlueprint, view: :authed
    association :user, blueprint: UserBlueprint, view: :authed
  end
end