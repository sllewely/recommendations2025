class RecommendationBlueprint < Blueprinter::Base
  identifier :id

  field :class_name do
    "Recommendation"
  end

  fields :title, :notes, :status, :rating, :url, :media_type, :who_recommended, :created_at

  association :comments, blueprint: CommentBlueprint, view: :authed, options: ->(options) { options }
  association :user, blueprint: UserBlueprint, view: :authed, options: ->(options) { options }
  association :reactions, blueprint: ReactionBlueprint

  # privacy settings are only shown to the owner
  field :visibility, if: ->(_field, obj, options) { options[:current_user]&.id == obj.user_id }
  field :audience, if: ->(_field, obj, options) { options[:current_user]&.id == obj.user_id }

  view :authed do
  end
end