class RsvpBlueprint < Blueprinter::Base
  identifier :id
  fields :status

  view :unauthed do

  end

  view :authed do
    association :user, blueprint: UserBlueprint, view: :authed, options: ->(options) { options }
  end
end