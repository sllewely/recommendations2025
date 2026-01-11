class FriendRequestBlueprint < Blueprinter::Base
  identifier :id
  association :user, blueprint: UserBlueprint
  association :incoming_friend, blueprint: UserBlueprint
  fields :created_at, :message, :status
end