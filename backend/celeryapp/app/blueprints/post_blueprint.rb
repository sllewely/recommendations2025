class PostBlueprint < Blueprinter::Base
  identifier :id

  field :class_name do
    "Post"
  end

  fields :title, :content, :created_at

  association :user, blueprint: UserBlueprint, view: :authed, options: ->(options) { options }
  association :comments, blueprint: CommentBlueprint, view: :authed, options: ->(options) { options }
  association :reactions, blueprint: ReactionBlueprint

  # anyone who can see it can see how it's shared; the audience is only shown to the owner
  field :visibility
  field :audience, if: ->(_field, obj, options) { options[:current_user]&.id == obj.user_id }

  view :authed do
  end
end