class Post < ApplicationRecord
  include DateHelper

  has_many :post_recommendations
  has_many :recommendations, through: :post_recommendations
  belongs_to :user
  has_many :comments, as: :commentable

  accepts_nested_attributes_for :recommendations

  validates :post_title, presence: true

  def attributes
    super.merge(
      { recommendations: recommendations,
        user: user.public_attributes,
        class_name: 'Post',
        create_date_string: get_date_string(created_at),
        create_time_string: get_time_string(created_at),
        creator_id: user.id,
        creator_name: user.name,
      })
  end

end
