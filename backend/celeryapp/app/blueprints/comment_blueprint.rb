class CommentBlueprint < Blueprinter::Base
  identifier :id

  fields :body, :id, :created_at
  association :user, blueprint: UserBlueprint, view: :authed
end
