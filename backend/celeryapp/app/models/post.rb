class Post < ApplicationRecord
  include DateHelper

  belongs_to :user
  has_many :comments, as: :commentable
  has_one :feed_item, as: :feedable

  validates :post_title, presence: true

  scope :by_friends, ->(friend_ids) { where(user_id: friend_ids) }

  def blueprint
    PostBlueprint
  end

  def create_date_string
    get_date_string(created_at)
  end

  def create_time_string
    get_time_string(created_at)
  end

  def attributes
    super.merge(
      {
        user: user.public_attributes,
        class_name: 'Post',
        create_date_string: get_date_string(created_at),
        create_time_string: get_time_string(created_at),
        creator_id: user.id,
        creator_name: user.name,
        comments: comments,
      })
  end

end
