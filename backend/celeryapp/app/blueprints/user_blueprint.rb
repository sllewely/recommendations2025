class UserBlueprint < Blueprinter::Base
  include S3ImageHelper

  identifier :id
  fields :id, :name, :presigned_url

  field :profile_photo_url do |user|
    if user.presigned_url.present?
      case Rails.env
      when "production"
        "prod.bumblebeans.xyz/profile_picture/#{user.id}"
      when "development"
        "dev.bumblebeans.xyz/profile_picture/#{user.id}"
      when "test"
        "test.test.xyz/profile_picture/#{user.id}"
      end
    end
  end

  view :unauthed do
  end

  view :authed do
    fields :blurb, :username, :calendar_api_key, :rss_api_key
    # field :tags do |user|
    #   user.tags.pluck(:tag)
    # end
    field :groups do |user, options|
      user.groups
    end
    field :friendship_status do |user, options|
      current = options[:current_user] || Current.user
      if current && user.id == current.id
        :self
      else
        statuses = options[:friend_statuses] || current&.friend_statuses
        if statuses
          statuses[user.id] || :none
        else
          :none
        end
      end
    end
  end

  view :self do
    include_view :authed
    field :email
  end
end