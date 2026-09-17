class CommentBlueprint < Blueprinter::Base
  identifier :id
  field :commentable_id

  view :unauthed do
    fields :id
  end

  view :authed do
    include_view :unauthed
    fields :body, :created_at
    association :user, blueprint: UserBlueprint, view: :authed, options: ->(options) { options }
  end
end
