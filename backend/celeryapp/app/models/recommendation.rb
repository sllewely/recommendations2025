class Recommendation < ApplicationRecord
  include DateHelper
  has_many :post_recommendations
  has_many :posts, through: :post_recommendations
  belongs_to :user

  enum :status, [:interested, :watching, :recommend]

  validates :title, presence: true

  def unrated?
    rating == 0 || rating.nil?
  end

  def attributes
    super.merge({
                  user: user.public_attributes,
                  class_name: 'Recommendation',
                  create_date_string: get_date_string(created_at),
                  create_time_string: get_time_string(created_at),
                  creator_id: user.id,
                  creator_name: user.name,
                })
  end
end
