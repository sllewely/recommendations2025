class Post < ApplicationRecord
  include DateHelper

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_one :feed_item, as: :feedable, dependent: :destroy

  validates :title, presence: true

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

end
