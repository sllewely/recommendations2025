class UserBlueprint < Blueprinter::Base
  include S3ImageHelper

  identifier :id
  fields :id, :name, :presigned_url

  view :unauthed do
  end

  view :authed do
    fields :blurb, :username
    # field :tags do |user|
    #   user.tags.pluck(:tag)
    # end
  end

  view :self do
    include_view :authed
    field :email
  end
end