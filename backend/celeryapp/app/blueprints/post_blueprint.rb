class PostBlueprint < Blueprinter::Base
  identifier :id

  field :class_name do
    "Post"
  end

  fields :title, :content, :created_at

  association :user, blueprint: UserBlueprint, view: :authed, options: ->(options) { options }
  association :comments, blueprint: CommentBlueprint, view: :authed, options: ->(options) { options }
  association :reactions, blueprint: ReactionBlueprint

  # privacy settings are only shown to the owner
  field :visibility, if: ->(_field, obj, options) { options[:current_user]&.id == obj.user_id }
  field :audience, if: ->(_field, obj, options) { options[:current_user]&.id == obj.user_id }

  view :authed do
  end
end