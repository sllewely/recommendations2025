class GroupBlueprint < Blueprinter::Base
  identifier :id
  field :name
  association :users, blueprint: UserBlueprint
  
end