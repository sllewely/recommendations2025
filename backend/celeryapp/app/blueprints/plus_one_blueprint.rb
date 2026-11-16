class PlusOneBlueprint < Blueprinter::Base
  identifier :id
  fields :name, :user_id

  # the user who brought them
  field :user_name do |plus_one|
    plus_one.user.name
  end
end
