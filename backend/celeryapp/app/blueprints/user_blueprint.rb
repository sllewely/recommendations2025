class UserBlueprint < Blueprinter::Base
  identifier :id
  fields :id, :name

  field :profile_picture do |user|
    if Rails.env.test?
      # skip this in test environment
      nil
    else
      S3ImageHelper.presigned_url_get_object("profile_picture/#{user.id}")
    end
  end

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