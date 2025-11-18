class PostBlueprint < Blueprinter::Base
  identifier :id

  field :class_name do
    "Post"
  end

  fields :title, :content, :created_at

  association :user, blueprint: UserBlueprint, view: :authed
  association :comments, blueprint: CommentBlueprint, view: :authed

  view :authed do
  end
end