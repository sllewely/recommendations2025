class PostBlueprint < Blueprinter::Base
  identifier :id

  field :class_name do
    "Post"
  end

  fields :post_title, :content, :create_date_string, :create_time_string

  association :user, blueprint: UserBlueprint, view: :authed
  association :comments, blueprint: CommentBlueprint, view: :authed

  view :authed do
  end
end