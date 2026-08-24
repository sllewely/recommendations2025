class ReactionBlueprint < Blueprinter::Base
  identifier :id

  fields :react, :created_at, :updated_at, :reactable_type, :reactable_id
  association :user, blueprint: UserBlueprint, view: :unauthed

end