class RsvpBlueprint < Blueprinter::Base
  identifier :id

  view :unauthed do
    fields :status
  end

  view :authed do
    include_view :unauthed
    association :user, blueprint: UserBlueprint, view: :authed
  end
end