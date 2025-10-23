class RecommendationBlueprint < Blueprinter::Base
  identifier :id

  field :class_name do
    "Recommendation"
  end

  fields :title, :notes, :status, :rating, :url, :media_type, :who_recommended, :create_date_string, :create_time_string

  association :comments, blueprint: CommentBlueprint, view: :authed
  association :user, blueprint: UserBlueprint, view: :authed

  view :authed do
  end
end