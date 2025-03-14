class Recommendation < ApplicationRecord
  has_many :post_recommendations
  has_many :posts, through: :post_recommendations
  belongs_to :user

  enum :status, [:interested, :watching, :recommend]

  def unrated?
    rating == 0 || rating.nil?
  end

  def attributes
    super.merge({
                  user: user.public_attributes,
                  class_name: 'Recommendation',
                })
  end
end
