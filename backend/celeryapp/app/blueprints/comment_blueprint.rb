class CommentBlueprint < Blueprinter::Base
  identifier :id

  view :unauthed do
    fields :id
  end

  view :authed do
    include_view :unauthed
    fields :body, :created_at
    association :user, blueprint: UserBlueprint, view: :authed
  end
end
