class PostBlueprint < Blueprinter::Base
  identifier :id

  field :class_name do
    "Post"
  end

  fields :title, :content, :created_at

  association :user, blueprint: UserBlueprint, view: :authed, options: ->(options) { options }
  association :comments, blueprint: CommentBlueprint, view: :authed, options: ->(options) { options }
  association :reactions, blueprint: ReactionBlueprint

  view :authed do
  end
end