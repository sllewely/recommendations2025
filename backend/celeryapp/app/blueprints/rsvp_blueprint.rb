class RsvpBlueprint < Blueprinter::Base
  identifier :id
  fields :status

  # anyone with the event link can see who's coming
  view :unauthed do
    association :user, blueprint: UserBlueprint, view: :unauthed
  end

  view :authed do
    association :user, blueprint: UserBlueprint, view: :authed, options: ->(options) { options }
  end
end