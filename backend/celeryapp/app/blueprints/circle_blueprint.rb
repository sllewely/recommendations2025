class CircleBlueprint < Blueprinter::Base
  identifier :id
  field :name
  association :members, blueprint: UserBlueprint
end