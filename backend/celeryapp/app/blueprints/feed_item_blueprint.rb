class FeedItemBlueprint < Blueprinter::Base
  identifier :id

  fields :id, :created_at
  association :feedable, blueprint: ->(feedable) { feedable.blueprint }, default: {}
end