class Recommendation < ApplicationRecord
  has_many :post_recommendations
  has_many :posts, through: :post_recommendations
  has_one :user

  enum :status, [:interested, :watching, :recommend]

  def unrated?
    rating == 0 || rating.nil?
  end

  def attributes
    super
  end
end
