class UserBlueprint < Blueprinter::Base
  identifier :id

  view :authed do
    fields :name, :blurb
  end

  # TODO: self view
end