class RecommendationBlueprint < Blueprinter::Base
  identifier :id

  field :class_name do
    "Recommendation"
  end

  fields :create_date_string, :create_time_string

  association :comments, blueprint: CommentBlueprint, view: :authed
  association :user, blueprint: UserBlueprint, view: :authed

end