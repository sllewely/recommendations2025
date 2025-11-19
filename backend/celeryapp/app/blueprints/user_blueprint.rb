class UserBlueprint < Blueprinter::Base
  identifier :id
  fields :id, :name

  view :unauthed do
  end

  view :authed do
    fields :blurb
  end

  # TODO: self view
end