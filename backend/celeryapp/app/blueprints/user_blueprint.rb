class UserBlueprint < Blueprinter::Base
  identifier :id

  view :unauthed do
    fields :id, :name
  end

  view :authed do
    include_view :unauthed
    fields :blurb
  end

  # TODO: self view
end