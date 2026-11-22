class RecommendationBlueprint < Blueprinter::Base
  identifier :id

  field :class_name do
    "Recommendation"
  end

  fields :title, :notes, :status, :rating, :url, :media_type, :who_recommended, :created_at

  association :comments, blueprint: CommentBlueprint, view: :authed, options: ->(options) { options }
  association :user, blueprint: UserBlueprint, view: :authed, options: ->(options) { options }
  association :reactions, blueprint: ReactionBlueprint

  # anyone who can see it can see how it's shared; the audience is only shown to the owner
  field :visibility
  field :audience, if: ->(_field, obj, options) { options[:current_user]&.id == obj.user_id }

  view :authed do
  end
end