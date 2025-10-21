class PostBlueprint < Blueprinter::Base
  identifier :id

  field :class_name do
    "Post"
  end

  fields :create_date_string, :create_time_string

  association :user, blueprint: UserBlueprint, view: :authed
  association :comments, blueprint: CommentBlueprint
end