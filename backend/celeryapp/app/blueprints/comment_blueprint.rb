class CommentBlueprint < Blueprinter::Base
  identifier :id

  field :class_name do
    "Comment"
  end

  field :commentable_id

  view :unauthed do
    fields :id
  end

  view :authed do
    include_view :unauthed
    fields :body, :created_at
    association :user, blueprint: UserBlueprint, view: :authed, options: ->(options) { options }
    association :reactions, blueprint: ReactionBlueprint
  end
end
